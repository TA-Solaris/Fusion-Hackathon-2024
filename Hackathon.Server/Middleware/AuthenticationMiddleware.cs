using System.Collections;
using System.Diagnostics.CodeAnalysis;
using System.Text;

namespace Hackathon.Server.Middleware
{
    public class AuthenticationMiddleware
    {

        private readonly RequestDelegate _next;

        public AuthenticationMiddleware(RequestDelegate next)
        {
            _next = next;
        }

        public async Task Invoke(HttpContext context)
        {
            if ((context.Request.Path.StartsWithSegments("/login") || context.Request.Path.StartsWithSegments("/register")) && context.Request.Headers.Count > 0)
            {
                var response = context.Response;
                var originBody = response.Body;
                using var newBody = new MemoryStream();
                response.Body = newBody;

                await _next(context);

                await ModifyResponseAsync(response);

                newBody.Seek(0, SeekOrigin.Begin);
                await newBody.CopyToAsync(originBody);
                response.Body = originBody;
                return;
            }

            if (context.Request.Headers.TryGetValue("app-authentication", out var value))
            {
                context.Request.Cookies = new Fuck(new Dictionary<string, string>() {
                    { ".AspNetCore.Identity.Application", value.ToString() },
                });
            }

            await _next(context);
        }

        private async Task ModifyResponseAsync(HttpResponse response)
        {
            var stream = response.Body;

            //uncomment to re-read the response stream
            //stream.Seek(0, SeekOrigin.Begin);
            using var reader = new StreamReader(stream, leaveOpen: true);
            string originalResponse = await reader.ReadToEndAsync();

            //add modification logic

            string modifiedResponse = $"HEADERS:{string.Join(";", response.Headers.Select(x => $"{x.Key}:{x.Value}"))};BODY:{response.Body}";
            stream.SetLength(0);
            using var writer = new StreamWriter(stream, leaveOpen: true);
            await writer.WriteAsync(modifiedResponse);
            await writer.FlushAsync();
            response.ContentLength = stream.Length;
        }

    }

    // Extension method used to add the middleware to the HTTP request pipeline.
    public static class HeaderToBodyMiddlewareExtensions
    {
        public static IApplicationBuilder UseHeaderToBodyMiddleware(this IApplicationBuilder builder)
        {
            return builder.UseMiddleware<AuthenticationMiddleware>();
        }
    }

    public class Fuck : IRequestCookieCollection
    {

        private Dictionary<string, string> shit = new Dictionary<string, string>();

        public string? this[string key] => shit[key];

        public int Count => shit.Count;

        public ICollection<string> Keys => shit.Keys;

        public bool ContainsKey(string key) => shit.ContainsKey(key);

        public IEnumerator<KeyValuePair<string, string>> GetEnumerator() => shit.GetEnumerator();

        public bool TryGetValue(string key, [NotNullWhen(true)] out string? value) => shit.TryGetValue(key, out value);

        IEnumerator IEnumerable.GetEnumerator() => shit.GetEnumerator();

        public Fuck(Dictionary<string, string> shit)
        {
            this.shit = shit;
        }
    }
}
