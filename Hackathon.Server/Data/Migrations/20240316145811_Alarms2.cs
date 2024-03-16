using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Hackathon.Server.Data.Migrations
{
    /// <inheritdoc />
    public partial class Alarms2 : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AlterColumn<string>(
                name: "UserId",
                table: "Alarms",
                type: "nvarchar(450)",
                nullable: true,
                oldClrType: typeof(long),
                oldType: "bigint");

            migrationBuilder.CreateIndex(
                name: "IX_Alarms_UserId",
                table: "Alarms",
                column: "UserId");

            migrationBuilder.AddForeignKey(
                name: "FK_Alarms_AspNetUsers_UserId",
                table: "Alarms",
                column: "UserId",
                principalTable: "AspNetUsers",
                principalColumn: "Id");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Alarms_AspNetUsers_UserId",
                table: "Alarms");

            migrationBuilder.DropIndex(
                name: "IX_Alarms_UserId",
                table: "Alarms");

            migrationBuilder.AlterColumn<long>(
                name: "UserId",
                table: "Alarms",
                type: "bigint",
                nullable: false,
                defaultValue: 0L,
                oldClrType: typeof(string),
                oldType: "nvarchar(450)",
                oldNullable: true);
        }
    }
}
