page 50117 "WebShop Restore Dialog"
{
    ApplicationArea = All;
    Caption = 'Restore Archived Etries';
    PageType = StandardDialog;
    UsageCategory = Administration;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'Period';
                field(StartDateCtrl; StartDate)
                {
                    ApplicationArea = All;
                    Caption = 'Start Date';
                    ToolTip = 'Enter the first date to restore.';
                }
                field(EndDateCtrl; EndDate)
                {
                    ApplicationArea = All;
                    Caption = 'End Date';
                    ToolTip = 'Enter the last date to restore. Use the same date for a single day.';
                }
            }
        }
    }

    var
        StartDate: Date;
        EndDate: Date;

    procedure SetDefaults(NewStartDate: Date; NewEndDate: Date)
    begin
        StartDate := NewStartDate;
        EndDate := NewEndDate;
    end;

    procedure GetStartDate(): Date
    begin
        exit(StartDate);
    end;

    procedure GetEndDate(): Date
    begin
        exit(EndDate);
    end;
}
