namespace Hackathon.Server.BusinessObjects
{
    public class SharedAlarmResult
    {

        public string[] Names { get; set; }

        public int[] Emojis { get; set; }

        public SharedAlarmResult(string[] names, int[] emojis)
        {
            Names = names;
            Emojis = emojis;
        }
    }
}
