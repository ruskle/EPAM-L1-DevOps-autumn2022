using System.ComponentModel.DataAnnotations;
using CarParking.Services;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;

namespace CarParking.Pages;

public class IndexModel : PageModel
{
    private readonly ILogger<IndexModel> _logger;
    private readonly CarParkingBill _carParkingBill;

    [BindProperty]
    public InputModel Input { get; set; }
    
    public IndexModel(ILogger<IndexModel> logger, CarParkingBill carParkingBill)
    {
        _logger = logger;
        _carParkingBill = carParkingBill;
    }

    public void OnGet()
    {
    }

    public string? parkingCost { get; set; }
    public IActionResult OnPost(InputModel input)
    {
        if (!ModelState.IsValid)
        {
            _logger.LogError(ModelState.ValidationState.ToString(), "Error validate input model");
            return RedirectToPage("Action");
        } 
        parkingCost = _carParkingBill.CarParkingCount(input);
        return Page();
    }
}

public class InputModel
{

    [Required] public DateTime ParkingStartTime { get; set; } = new DateTime();

    [Required] public DateTime ParkingEndTime { get; set; } = new DateTime();
}