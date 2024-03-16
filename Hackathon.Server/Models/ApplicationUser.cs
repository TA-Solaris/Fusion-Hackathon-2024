using Microsoft.AspNetCore.Identity;

namespace Hackathon.Server.Models
{
    public class ApplicationUser : IdentityUser
    {

        public List<ApplicationUser> FriendRequests { get; set; } = [];

        public List<ApplicationUser> Friends { get; set; } = [];

        public int Gems { get; set; } = 0;

    }
}
