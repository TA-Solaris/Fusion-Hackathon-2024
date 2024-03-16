using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Hackathon.Server.Data.Migrations
{
    /// <inheritdoc />
    public partial class UserGems : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<int>(
                name: "Gems",
                table: "AspNetUsers",
                type: "int",
                nullable: false,
                defaultValue: 0);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "Gems",
                table: "AspNetUsers");
        }
    }
}
