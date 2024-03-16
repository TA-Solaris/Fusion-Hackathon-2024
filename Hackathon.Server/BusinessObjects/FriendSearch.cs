namespace Hackathon.Server.BusinessObjects
{
    public class FriendSearch
    {

        public string UserId { get; set; }

        public string UserName { get; set; }

        public bool IsFriend { get; set; }

        public bool SentFriendRequest { get; set; }

        public FriendSearch(string userId, string userName, bool isFriend, bool sentFriendRequest)
        {
            UserId = userId;
            UserName = userName;
            IsFriend = isFriend;
            SentFriendRequest = sentFriendRequest;
        }
    }
}
