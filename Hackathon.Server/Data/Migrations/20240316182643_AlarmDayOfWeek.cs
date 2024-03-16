using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Hackathon.Server.Data.Migrations
{
    /// <inheritdoc />
    public partial class AlarmDayOfWeek : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<byte>(
                name: "DaysSet",
                table: "Alarms",
                type: "tinyint",
                nullable: false,
                defaultValue: (byte)0);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "DaysSet",
                table: "Alarms");
        }
    }
}
