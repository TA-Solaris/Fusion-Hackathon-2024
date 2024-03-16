using Microsoft.AspNetCore.SignalR;

namespace Hackathon.Server.Hubs
{
    public class ReactionHub : Hub
    {

        public async Task SendReaction(int emojiId)
        {
            await Clients.All.SendAsync("DisplayEmoji", emojiId);
        }

    }
}
