namespace Hackathon.Server.BusinessObjects
{
    public class FriendRequest
    {

        public string Id { get; set; }

        public string Name { get; set; }

        public FriendRequest(string id, string name)
        {
            Id = id;
            Name = name;
        }
    }
}
