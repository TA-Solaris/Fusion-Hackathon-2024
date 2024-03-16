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
        private readonly UserManager<IdentityUser> _userManager;

        public AlarmController(ApplicationDbContext context, UserManager<IdentityUser> userManager)
        {
            _context = context;
            _userManager = userManager;
        }

        // GET: api/Alarm
        [HttpGet]
        [Authorize]
        public async Task<ActionResult<IEnumerable<AlarmModel>>> GetAlarms()
        {
            IdentityUser? user = await _userManager.GetUserAsync(User);
            return await _context.Alarms
                .Where(alarm => alarm.User == user)
                .ToListAsync();
        }

        // GET: api/Alarm/5
        [HttpGet("{id}")]
        [Authorize]
        public async Task<ActionResult<AlarmModel>> GetAlarmModel(long id)
        {
            var alarmModel = await _context.Alarms.FindAsync(id);

            if (alarmModel == null)
            {
                return NotFound();
            }

            IdentityUser? user = await _userManager.GetUserAsync(User);
            if (user == null)
                return BadRequest();
            if (alarmModel.User != user)
                return Unauthorized();

            return alarmModel;
        }

        // POST: api/Alarm
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPost]
        [Authorize]
        public async Task<ActionResult<AlarmModel>> PostAlarmModel(DateTime alarmTime)
        {
            IdentityUser? user = await _userManager.GetUserAsync(User);
            if (user == null)
                return BadRequest();
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
        [Authorize]
        public async Task<IActionResult> DeleteAlarmModel(long id)
        {
            var alarmModel = await _context.Alarms.FindAsync(id);
            if (alarmModel == null)
            {
                return NotFound();
            }

            IdentityUser? user = await _userManager.GetUserAsync(User);
            if (user == null)
                return BadRequest();
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

        [Authorize]
        [HttpPut("TriggerAlarm/{id}")]
        public async Task<ActionResult<AlarmModel>> TriggerAlarm(long id)
        {
            IdentityUser? user = await _userManager.GetUserAsync(User);
            if (user == null)
                return BadRequest();
            var alarmModel = await _context.Alarms.FindAsync(id);
            if (alarmModel == null)
                return BadRequest();
            if (alarmModel.User != user)
                return Unauthorized();
            if (!alarmModel.IsAlarmReady())
                return BadRequest();
            alarmModel.TimesAccepted++;
            alarmModel.LastTime = DateTime.Now;
            await _context.SaveChangesAsync();
            return alarmModel;
        }

    }
}
