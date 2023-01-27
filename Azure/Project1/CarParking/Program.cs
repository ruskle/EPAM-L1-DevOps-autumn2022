using CarParking.Services;
using Microsoft.AspNetCore.HttpOverrides;
using NLog;
using NLog.Web;

var logger = NLog.LogManager.Setup().LoadConfigurationFromAppSettings().GetCurrentClassLogger();
logger.Debug("init main");

try
{
    var builder = WebApplication.CreateBuilder(args);

    // Add services to the container.
    builder.Services.AddRazorPages();
    builder.Services.AddSingleton<CarParkingBill>();

    // NLog: Setup NLog for Dependency injection
    // Для расширенного логирования данных запроса HTML
    builder.Logging.ClearProviders();
    builder.Logging.SetMinimumLevel(Microsoft.Extensions.Logging.LogLevel.Trace);
    builder.Host.UseNLog();
    
    builder.WebHost.ConfigureKestrel(options =>
    {
        options.ListenAnyIP(5001); // to listen for incoming http connection on port 5001
    });
    
    var app = builder.Build();
    
    app.UseForwardedHeaders(new ForwardedHeadersOptions
    {
        ForwardedHeaders = ForwardedHeaders.XForwardedFor | ForwardedHeaders.XForwardedProto
    });

    // Configure the HTTP request pipeline.
    if (!app.Environment.IsDevelopment())
    {
        app.UseExceptionHandler("/Error");
        app.UseHsts();
    }
    app.UseStatusCodePagesWithReExecute("/{0}");
    //app.UseHttpsRedirection();
    app.UseStaticFiles();
    app.UseRouting();
    app.MapRazorPages();

    app.Run();
}
catch (Exception e)
{
    logger.Error(e, "Stopped program because of exception"); // Логируем в файл
    throw;
}
finally
{
    // Ensure to flush and stop internal timers/threads before application-exit (Avoid segmentation fault on Linux)
    LogManager.Shutdown();
}
