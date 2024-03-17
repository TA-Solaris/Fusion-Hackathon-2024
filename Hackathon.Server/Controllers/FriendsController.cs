using Hackathon.Server.BusinessObjects;
using Hackathon.Server.Data;
using Hackathon.Server.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Linq;

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
        public async Task<ActionResult<IEnumerable<FriendSearch>>> SearchUsers(string username, string authentication)
        {
            ApplicationUser? user = await AuthenticationController.VerifyLogin(_context, authentication);
            if (user == null)
                return Unauthorized();
            return await _context.Users
                .Where(friend => friend.UserName != null && friend.UserName.Contains(username))
                .Select(friend => new FriendSearch(friend.Id, friend.UserName!, user.FriendIds.Contains(friend.Id), friend.FriendRequestIds.Contains(user.Id)))
                .Take(50)
                .ToListAsync();
        }

        [HttpPost("SendRequest/{userId}")]
        public async Task<ActionResult> SendFriendRequest(string userId, string authentication)
        {
            ApplicationUser? user = await AuthenticationController.VerifyLogin(_context, authentication);
            if (user == null)
                return Unauthorized();
            ApplicationUser? friend = _context.Users
                .Where(x => x.Id == userId)
                .First();
            if (friend == null)
                return NotFound();
            if (user.FriendIds.Contains(friend.Id) || friend.FriendIds.Contains(user.Id))
                return BadRequest("You are already friends with this user.");
            if (friend.FriendRequestIds.Contains(user.Id))
                return BadRequest("You have already sent a friend request to this user.");
            if (user.FriendRequestIds.Contains(friend.Id))
            {
                user.FriendRequestIds.Remove(friend.Id);
                friend.FriendRequestIds.Remove(user.Id);
                user.FriendIds.Add(friend.Id);
                friend.FriendIds.Add(user.Id);
                await _context.SaveChangesAsync();
                return Ok("Friend request accepted");
            }
            friend.FriendRequestIds.Add(user.Id);
            await _context.SaveChangesAsync();
            return Ok("Friend request sent");
        }

        [HttpPost("GetRequests")]
        public async Task<ActionResult<IEnumerable<FriendRequest>>> GetFriendRequests(string authentication)
        {
            ApplicationUser? user = await AuthenticationController.VerifyLogin(_context, authentication);
            if (user == null)
                return Unauthorized();
            return Ok(user.FriendRequestIds
                .Select(async friend => new FriendRequest(friend, (await _context.Users.FindAsync(friend)).UserName!)));
        }

        [HttpGet("GetAll")]
        public async Task<ActionResult<IEnumerable<FriendRequest>>> GetFriends(string authentication)
        {
            ApplicationUser? user = await AuthenticationController.VerifyLogin(_context, authentication);
            if (user == null)
                return Unauthorized();
            var result = await _context.Users
                .Where(x => x.FriendIds.Any(friend => friend == user.Id))
                .ToListAsync();
            return Ok(result);
        }

        [HttpPost("AcceptRequest/{friendId}")]
        [Authorize]
        public async Task<ActionResult> AcceptFriendRequest(string friendId, string authentication)
        {
            ApplicationUser? user = await AuthenticationController.VerifyLogin(_context, authentication);
            if (user == null)
                return Unauthorized();
            ApplicationUser? friend = _context.Users
                .Where(x => x.Id == friendId)
                .First();
            if (friend == null)
                return Unauthorized();
            if (!user.FriendRequestIds.Contains(friend.Id))
                return NotFound();
            user.FriendRequestIds.Remove(friend.Id);
            user.FriendIds.Add(friend.Id);
            friend.FriendIds.Add(user.Id);
            await _context.SaveChangesAsync();
            return Ok();
        }

        [HttpPost("Sabotage/{targetId}")]
        [Authorize]
        public async Task<ActionResult> Sabotage(string targetId, string authentication)
        {
            ApplicationUser? user = await AuthenticationController.VerifyLogin(_context, authentication);
            if (user == null)
                return Unauthorized();
            if (user.Gems < 36)
                return NotFound();
            user.Gems -= 36;
            ApplicationUser? friend = await _context.Users.FindAsync(targetId);
            if (friend == null)
                return NotFound();
            var alarms = await _context.Alarms
                .Where(alarm => alarm.User.Id == friend.Id)
                .ToListAsync();
            var alarm = alarms[Random.Shared.Next(alarms.Count)];
            alarm.Time = alarm.Time += TimeSpan.FromMinutes(Random.Shared.Next(20) - 10);
            await _context.SaveChangesAsync();
            return Ok();
        }

    }
}
