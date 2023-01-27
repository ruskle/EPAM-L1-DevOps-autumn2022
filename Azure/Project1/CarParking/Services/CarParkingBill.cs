using CarParking.Pages;

namespace CarParking.Services;

public class CarParkingBill
{
    private readonly ILogger<CarParkingBill> _logger; // Подключаем логирование
    private double cost1 = 70.0;
    private double cost2 = 100.0;

    public CarParkingBill(ILogger<CarParkingBill> logger)
    {
        _logger = logger;
    }
   
    public string CarParkingCount(InputModel inputModel)
    {
        double total = 0;
        try
        {
            foreach (var (start, end) in EnumerateDays(inputModel.ParkingStartTime, inputModel.ParkingEndTime))
            {
                if (start.TimeOfDay == TimeSpan.FromHours(0) && end.TimeOfDay == TimeSpan.FromHours(0)) // Парковка целый день с 00:00 по 23:59:59
                {
                    total += ((7 * cost1) + (12 * cost2) + (5 * cost1)); // Три временных отрезка 00:00-07:00, 07:00-19:00 и 19:00-23:59:59
                }
                else if (start.TimeOfDay >= TimeSpan.FromHours(0) && start.TimeOfDay <= TimeSpan.FromHours(7)) // Парковка, начало с 00:00 до 07:00
                {
                    total += ParkingInterval1(start, end);
                } 
                else if (start.TimeOfDay > TimeSpan.FromHours(7) && start.TimeOfDay <= TimeSpan.FromHours(19)) // Парковка с началом с 07:00 по 19:00
                {
                    total += ParkingInterval2(start, end);
                }
                else if (start.TimeOfDay > TimeSpan.FromHours(19) && start.TimeOfDay <= new TimeSpan(23,59,59)) // Парковка с 19:00 по 00:00
                {
                    total += ParkingInterval3(start, end);
                }
            }
        }
        catch (Exception e)
        {
            _logger.LogError(e,"Error to check parking time");
            throw;
        }
        return String.Format("{0:0.##}",total);
    }
    
    
    // Service methods
    private bool IsWeekend(DateTime date) => date.DayOfWeek is DayOfWeek.Saturday or DayOfWeek.Sunday;

    private IEnumerable<(DateTime start, DateTime end)> EnumerateDays(DateTime start, DateTime end)
    {
        var nextDay = start.Date.AddDays(1);
        while (nextDay < end)
        {
            yield return (start, nextDay);
            (start, nextDay) = (nextDay, nextDay.AddDays(1));
        }
        yield return (start, end);
    }

    private double ParkingInterval1(DateTime start, DateTime end) // Парковка, начало с 00:00 до 07:00
    {
        double parkCost = 0.0;
        if (end.TimeOfDay <= TimeSpan.FromHours(7)) // Парковка окончание до 07:00
        {
            TimeSpan interval = end - start;
            parkCost += cost1 * interval.TotalHours;
        }
        else if (end.TimeOfDay > TimeSpan.FromHours(7) && end.TimeOfDay <= TimeSpan.FromHours(19)) // Парковка, окончание с 07:00 до 19:00
        {
            TimeSpan interval1 = (new DateTime(start.Year, start.Month, start.Day, 7, 0, 0) - start);
            TimeSpan interval2 = (end - new DateTime(start.Year, start.Month, start.Day,7,0,0));
            parkCost += (interval1.TotalHours * cost1) + (interval2.TotalHours * cost2);
        }
        else if (end.TimeOfDay > TimeSpan.FromHours(19)) // Парковка, окончание после 19:00
        {
            TimeSpan interval1 = (new DateTime(start.Year, start.Month, start.Day, 7, 0, 0) - start);
            TimeSpan interval3 = (end - new DateTime(start.Year, start.Month, start.Day, 19, 0, 0));
            parkCost += (interval1.TotalHours * cost1) + (12 * cost2) + (interval3.TotalHours * cost1);
        }
        if (IsWeekend(start) || IsWeekend(end)) parkCost -= parkCost * 0.20;
        return parkCost;
    }
    
    private double ParkingInterval2(DateTime start, DateTime end) // Парковка с началом с 07:00 по 19:00
    {
        double parkCost = 0.0;
        if (end.TimeOfDay <= TimeSpan.FromHours(19)) // Парковка, окончание с 07:00 до 19:00
        {
            TimeSpan interval = end - start;
            parkCost += cost2 * interval.TotalHours;
        }
        else if (end.TimeOfDay > TimeSpan.FromHours(19)) // Парковка, окончание после 19:00
        {
            TimeSpan interval1 = (new DateTime(start.Year, start.Month, start.Day, 19, 0, 0) - start);
            TimeSpan interval2 = (end - new DateTime(start.Year, start.Month, start.Day,19,0,0));
            parkCost += (interval1.TotalHours * cost2) + (interval2.TotalHours * cost1);
        }
        if (IsWeekend(start) || IsWeekend(end)) parkCost -= parkCost * 0.20;
        return parkCost;
    }
    
    private double ParkingInterval3(DateTime start, DateTime end) // Парковка с 19:00 по 00:00
    {
        double parkCost = 0.0;
        TimeSpan interval = end - start; // Парковка, окончание с 19:00 до 23:59:59
        parkCost += cost1 * interval.TotalHours;
        if (IsWeekend(start) || IsWeekend(end)) parkCost -= parkCost * 0.20;
        return parkCost;
    }
}
