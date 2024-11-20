namespace VirtualPrinter.VirtualPrinter;

table 50150 "DRG VP Setup"
{
    Caption = 'Virtual Printer Setup';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "No."; Code[10])
        {
            Caption = 'No.';
        }
        field(10; "Print API URL"; Text[250])
        {
            Caption = 'Print API URL';
        }
    }
    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
    }
}
