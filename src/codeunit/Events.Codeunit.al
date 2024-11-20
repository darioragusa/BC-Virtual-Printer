namespace VirtualPrinter.VirtualPrinter;

using Microsoft.Foundation.Reporting;

// https://learn.microsoft.com/en-us/dynamics365/business-central/dev-itpro/developer/devenv-reports-create-printer-extension

codeunit 50150 "DRG VP Events"
{

    // {
    //     "version": 1,
    //     "description":[default=""],
    //     "duplex":[default=false],
    //     "color":[default=false],
    //     "defaultcopies":[default=1],
    //     "papertrays":  
    //     [
    //         {
    //             "papersourcekind":'Upper' | 1, 
    //             "paperkind":'A4' | 9,
    //             "units":[default='HI'],
    //             "height":[default=0],
    //             "width":[default=0],
    //             "landscape":[default=false]
    //         }
    //     ]
    // }

    [EventSubscriber(ObjectType::Codeunit, Codeunit::ReportManagement, 'OnAfterSetupPrinters', '', false, false)]
    local procedure OnAfterSetupPrinters(var Printers: Dictionary of [Text[250], JsonObject])
    var
        PaperTray: JsonObject;
    begin
        PaperTray.Add('papersourcekind', 'Upper');
        PaperTray.Add('paperkind', 'A4');
        Printers.Add('Virtual Printer A4', this.CreaePrinterFromPaperTray(PaperTray));

        Clear(PaperTray);
        PaperTray.Add('papersourcekind', 'Custom');
        PaperTray.Add('paperkind', 'Custom');
        PaperTray.Add('width', 100);
        PaperTray.Add('height', 100);
        PaperTray.Add('units', 'mm');
        Printers.Add('Virtual Printer 100mm', this.CreaePrinterFromPaperTray(PaperTray));
    end;

    local procedure CreaePrinterFromPaperTray(PaperTray: JsonObject) Payload: JsonObject
    var
        PaperTrays: JsonArray;
    begin
        PaperTrays.Add(PaperTray);
        Payload.Add('version', 1);
        Payload.Add('papertrays', PaperTrays);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::ReportManagement, 'OnAfterDocumentPrintReady', '', true, true)]
    local procedure OnAfterDocumentPrintReady(ObjectType: Option "Report","Page"; ObjectId: Integer; ObjectPayload: JsonObject; DocumentStream: InStream; var Success: Boolean)
    var
        VPSetup: Record "DRG VP Setup";
        ContentHeaders: HttpHeaders;
        Content: HttpContent;
        ReqMessage: HttpRequestMessage;
        Client: HttpClient;
        RespMessage: HttpResponseMessage;
        PrinterNameToken: JsonToken;
        PrinterName: Text;
    begin
        if Success then
            exit;
        if not VPSetup.Get() then
            exit;
        ObjectPayload.Get('printername', PrinterNameToken);
        PrinterName := PrinterNameToken.AsValue().AsText();
        if PrinterName in ['Virtual Printer A4', 'Virtual Printer 100mm'] then begin
            Content.WriteFrom(DocumentStream);

            Content.GetHeaders(ContentHeaders);
            if ContentHeaders.Contains('Content-Type') then
                ContentHeaders.Remove('Content-Type');
            ContentHeaders.Add('Content-Type', 'application/octet-stream');

            ReqMessage.Content := Content;
            if Client.Post(VPSetup."Print API URL", Content, RespMessage) then
                Success := RespMessage.IsSuccessStatusCode();
            exit;
        end;

    end;
}