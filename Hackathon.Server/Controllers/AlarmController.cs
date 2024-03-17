using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Hackathon.Server.Data;
using Hackathon.Server.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Identity;

namespace Hackathon.Server.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class AlarmController : ControllerBase
    {
        private readonly ApplicationDbContext _context;
        private readonly UserManager<ApplicationUser> _userManager;

        public AlarmController(ApplicationDbContext context, UserManager<ApplicationUser> userManager)
        {
            _context = context;
            _userManager = userManager;

            _ = Task.Run(async () => {
                while (true)
                {
                    lock (RingingAlarms)
                    {
                        foreach (var alarm in RingingAlarms.Where(alarm => alarm.LastTime < DateTime.Now - TimeSpan.FromMinutes(5)).ToList())
                        {
                            RingingAlarms.Remove(alarm);
                        }
                    }
                    await Task.Delay(60000);
                }
            });
        }

        // GET: api/Alarm
        [HttpGet("GetAll")]
        public async Task<ActionResult<IEnumerable<AlarmModel>>> GetAlarms(string authentication)
        {
            ApplicationUser? user = await AuthenticationController.VerifyLogin(_context, authentication);
            if (user == null)
                return Unauthorized();
            return await _context.Alarms
                .Where(alarm => alarm.User == user)
                .ToListAsync();
        }

        // GET: api/Alarm/5
        [HttpGet("{id}")]
        public async Task<ActionResult<AlarmModel>> GetAlarmModel(long id, string authentication)
        {
            var alarmModel = await _context.Alarms.FindAsync(id);

            if (alarmModel == null)
            {
                return NotFound();
            }

            ApplicationUser? user = await AuthenticationController.VerifyLogin(_context, authentication);
            if (user == null)
                return Unauthorized();
            if (user == null)
                return BadRequest();
            if (alarmModel.User != user)
                return Unauthorized();

            return alarmModel;
        }

        // POST: api/Alarm
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPost]
        public async Task<ActionResult<AlarmModel>> PostAlarmModel(DateTime alarmTime, string authentication)
        {
            ApplicationUser? user = await AuthenticationController.VerifyLogin(_context, authentication);
            if (user == null)
                return Unauthorized();
            // Create a new alarm
            AlarmModel alarm = new AlarmModel()
            {
                User = user,
                Time = alarmTime
            };

            _context.Alarms.Add(alarm);
            await _context.SaveChangesAsync();

            return CreatedAtAction(nameof(GetAlarmModel), new { id = alarm.Id }, alarm);
        }

        // DELETE: api/Alarm/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteAlarmModel(long id, string authentication)
        {
            var alarmModel = await _context.Alarms.FindAsync(id);
            if (alarmModel == null)
            {
                return NotFound();
            }

            ApplicationUser? user = await AuthenticationController.VerifyLogin(_context, authentication);
            if (user == null)
                return Unauthorized();
            if (alarmModel.User != user)
                return Unauthorized();

            _context.Alarms.Remove(alarmModel);
            await _context.SaveChangesAsync();

            return NoContent();
        }

        private bool AlarmModelExists(long id)
        {
            return _context.Alarms.Any(e => e.Id == id);
        }

        private static HashSet<AlarmModel> RingingAlarms { get; } = new HashSet<AlarmModel>();

        [HttpPut("TriggerAlarm/{id}")]
        public async Task<ActionResult<AlarmModel>> TriggerAlarm(long id, string authentication)
        {
            ApplicationUser? user = await AuthenticationController.VerifyLogin(_context, authentication);
            if (user == null)
                return Unauthorized();
            var alarmModel = await _context.Alarms.FindAsync(id);
            if (alarmModel == null)
                return BadRequest();
            if (alarmModel.User != user)
                return Unauthorized();
            if (!alarmModel.IsAlarmReady())
                return BadRequest();
            lock (RingingAlarms)
            {
                if (!RingingAlarms.Contains(alarmModel))
                    RingingAlarms.Add(alarmModel);
            }
            alarmModel.TimesAccepted++;
            alarmModel.LastTime = DateTime.Now;
            await _context.SaveChangesAsync();
            return alarmModel;
        }

        [HttpPut("StopAlarm/{id}")]
        public async Task<ActionResult> StopAlarm(long id, string authentication)
        {
            ApplicationUser? user = await AuthenticationController.VerifyLogin(_context, authentication);
            if (user == null)
                return Unauthorized();
            var alarmModel = await _context.Alarms.FindAsync(id);
            if (alarmModel == null)
                return BadRequest();
            if (alarmModel.User != user)
                return Unauthorized();
            lock (RingingAlarms)
            {
                if (RingingAlarms.Contains(alarmModel))
                    RingingAlarms.Remove(alarmModel);
            }
            return Ok();
        }

        [HttpPut("SetAlarmTime/{id}")]
        public async Task<ActionResult<AlarmModel>> SetAlarmTime(long id, DateTime newTime, string authentication)
        {
            ApplicationUser? user = await AuthenticationController.VerifyLogin(_context, authentication);
            if (user == null)
                return Unauthorized();
            var alarmModel = await _context.Alarms.FindAsync(id);
            if (alarmModel == null)
                return BadRequest();
            if (alarmModel.User != user)
                return Unauthorized();
            if (!alarmModel.IsAlarmReady())
                return BadRequest();
            alarmModel.Time = newTime;
            // When you change an alarms time, the time updates so that you can't cheat the streaks
            alarmModel.LastTime = DateTime.Now;
            await _context.SaveChangesAsync();
            return alarmModel;
        }

        [HttpGet("GetSharedAlarms/{id}")]
        public async Task<ActionResult<int>> GetSharedAlarmCount(long id, string authentication)
        {
            ApplicationUser? user = await AuthenticationController.VerifyLogin(_context, authentication);
            if (user == null)
                return Unauthorized();
            var alarmModel = await _context.Alarms.FindAsync(id);
            if (alarmModel == null)
                return BadRequest();
            if (alarmModel.User != user)
                return Unauthorized();
            lock (RingingAlarms)
            {
                return RingingAlarms.Count;
            }
        }

    }
}
