using Microsoft.AspNetCore.Identity;

namespace Hackathon.Server.Models
{
    public class ApplicationUser : IdentityUser
    {

        public List<string> FriendRequestIds { get; set; } = [];

        public List<string> FriendIds { get; set; } = [];

        public int Gems { get; set; } = 0;

    }
}
