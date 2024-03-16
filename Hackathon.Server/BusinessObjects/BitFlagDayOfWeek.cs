namespace Hackathon.Server.BusinessObjects
{
    public enum BitFlagDayOfWeek : byte
    {
        ALL = MONDAY | TUESDAY | WEDNESDAY | THURSDAY | FRIDAY | SATURDAY | SUNDAY,
        MONDAY = 1 << 0,
        TUESDAY = 1 << 1,
        WEDNESDAY = 1 << 2,
        THURSDAY = 1 << 3,
        FRIDAY = 1 << 4,
        SATURDAY = 1 << 5,
        SUNDAY = 1 << 6,
    }
}
