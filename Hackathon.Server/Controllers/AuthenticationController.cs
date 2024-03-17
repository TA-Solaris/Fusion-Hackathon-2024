using Azure.Core;
using Hackathon.Server.Data;
using Hackathon.Server.Models;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using System.Text;

namespace Hackathon.Server.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class AuthenticationController : Controller
    {

        private readonly ApplicationDbContext _context;
        private readonly UserManager<ApplicationUser> _userManager;

        public AuthenticationController(ApplicationDbContext context, UserManager<ApplicationUser> userManager)
        {
            _context = context;
            _userManager = userManager;
        }

        [HttpGet("/api/attemptLogin")]
        public async Task<ActionResult<string>> AttemptLogin(string username, string password)
        {
            var user = _context.Users.Where(x => x.UserName == username).First();
            if (user == null)
                return NotFound();
            var hasher = new PasswordHasher<ApplicationUser>();
            var verificationResult = hasher.VerifyHashedPassword(user, user.PasswordHash, password);
            if (verificationResult == PasswordVerificationResult.Failed)
            {
                return Unauthorized();
            }
            // Issue a new access token
            byte[] token = new byte[256];
            Random.Shared.NextBytes(token);
            // Store the authentication token in the database
            var authenticationModel = new AuthModel(user.Id, Convert.ToBase64String(token));
            _context.AuthTokens.Add(authenticationModel);
            await _context.SaveChangesAsync();
            return Ok(authenticationModel.AuthKey);
        }

        public static async Task<ApplicationUser?> VerifyLogin(ApplicationDbContext _context, string accessToken)
        {
            var authenticationResult = await _context.AuthTokens.FindAsync(accessToken);
            if (authenticationResult == null)
                return null;
            return _context.Users.Find(authenticationResult.UserId);
        }

    }
}
