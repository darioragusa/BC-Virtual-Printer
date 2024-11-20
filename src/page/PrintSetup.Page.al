namespace VirtualPrinter.VirtualPrinter;

page 50150 "DRG VP Print Setup"
{
    ApplicationArea = All;
    Caption = 'API Print Setup';
    PageType = Card;
    SourceTable = "DRG VP Setup";
    UsageCategory = Administration;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("Print API URL"; Rec."Print API URL")
                {
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        if not Rec.Get() then begin
            Rec.Init();
            Rec.Insert();
        end;
    end;
}
