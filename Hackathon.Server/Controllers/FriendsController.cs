using Hackathon.Server.BusinessObjects;
using Hackathon.Server.Data;
using Hackathon.Server.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace Hackathon.Server.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class FriendsController : ControllerBase
    {

        private readonly ApplicationDbContext _context;
        private readonly UserManager<ApplicationUser> _userManager;

        public FriendsController(ApplicationDbContext context, UserManager<ApplicationUser> userManager)
        {
            _context = context;
            _userManager = userManager;
        }

        [HttpGet("Search/{username}")]
        [Authorize]
        public async Task<ActionResult<IEnumerable<FriendSearch>>> SearchUsers(string username)
        {
            ApplicationUser? user = await _userManager.GetUserAsync(User);
            if (user == null)
                return Unauthorized();
            return await _context.Users
                .Where(friend => friend.UserName != null && friend.UserName.Contains(username))
                .Select(friend => new FriendSearch(friend.Id, friend.UserName!, user.Friends.Contains(friend), friend.FriendRequests.Contains(user)))
                .Take(50)
                .ToListAsync();
        }

        [HttpPost("SendRequest/{userId}")]
        [Authorize]
        public async Task<ActionResult> SendFriendRequest(string userId)
        {
            ApplicationUser? user = await _userManager.GetUserAsync(User);
            if (user == null)
                return Unauthorized();
            ApplicationUser? friend = await _context.Users.FindAsync(userId);
            if (friend == null)
                return NotFound();
            if (user.Friends.Contains(friend))
                return BadRequest("You are already friends with this user.");
            if (friend.FriendRequests.Contains(user))
                return BadRequest("You have already sent a friend request to this user.");
            if (user.FriendRequests.Contains(friend))
            {
                user.FriendRequests.Remove(friend);
                user.Friends.Add(friend);
                friend.Friends.Add(user);
                await _context.SaveChangesAsync();
                return Ok("Friend request accepted");
            }
            friend.FriendRequests.Add(user);
            await _context.SaveChangesAsync();
            return Ok("Friend request sent");
        }

        [HttpPost("GetRequests")]
        [Authorize]
        public async Task<ActionResult<IEnumerable<FriendRequest>>> GetFriendRequests()
        {
            ApplicationUser? user = await _userManager.GetUserAsync(User);
            if (user == null)
                return Unauthorized();
            return Ok(user.FriendRequests
                .Select(friend => new FriendRequest(friend.Id, friend.UserName!)));
        }

        [HttpPost("AcceptRequest/{friendId}")]
        [Authorize]
        public async Task<ActionResult> AcceptFriendRequest(string friendId)
        {
            ApplicationUser? user = await _userManager.GetUserAsync(User);
            if (user == null)
                return Unauthorized();
            ApplicationUser? friend = await _context.Users.FindAsync(friendId);
            if (friend == null)
                return Unauthorized();
            if (!user.FriendRequests.Contains(friend))
                return NotFound();
            user.FriendRequests.Remove(friend);
            user.Friends.Add(friend);
            friend.Friends.Add(user);
            await _context.SaveChangesAsync();
            return Ok();
        }

    }
}
