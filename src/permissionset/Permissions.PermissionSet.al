namespace VirtualPrinter.VirtualPrinter;

using VirtualPrinter.VirtualPrinter;

permissionset 50150 "DRG VP Permissions"
{
    Assignable = true;
    Permissions =
        tabledata "DRG VP Setup" = RIMD,
        table "DRG VP Setup" = X,
        codeunit "DRG VP Events" = X,
        page "DRG VP Print Setup" = X;
}