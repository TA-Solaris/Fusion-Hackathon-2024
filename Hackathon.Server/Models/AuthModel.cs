using Microsoft.EntityFrameworkCore;

namespace Hackathon.Server.Models
{
    [PrimaryKey("AuthKey")]
    public class AuthModel
    {

        public string AuthKey { get; set; }

        public string UserId { get; set; }

        public AuthModel(string userId, string authKey)
        {
            AuthKey = authKey;
            UserId = userId;
        }
    }
}
