using Microsoft.AspNetCore.Identity;
using Newtonsoft.Json;
using System.ComponentModel.DataAnnotations;

namespace Hackathon.Server.Models
{
    public class AlarmModel
    {

        public static TimeSpan alarmCooldown = TimeSpan.FromMinutes(1);

        public long Id { get; set; }

        [JsonIgnore]
        [ProtectedPersonalData]
        public IdentityUser User { get; set; }

        public DateTime Time { get; set; }

        public int TimesAccepted { get; set; } = 0;

        /// <summary>
        /// The last time that the user last accepted this alarm.
        /// </summary>
        [JsonIgnore]
        public DateTime LastTime { get; set; }

        /// <summary>
        /// Check if the alarm is ready to be activated.
        /// The user may be exploiting if this is not set.
        /// </summary>
        /// <returns></returns>
        public bool IsAlarmReady()
        {
            return DateTime.Now > LastTime + alarmCooldown;
        }

    }
}
