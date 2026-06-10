page 50131 "KCX Job Queue Email Test"
{
    ApplicationArea = All;
    Caption = 'KCX Job Queue Email Test';
    PageType = Card;
    UsageCategory = Administration;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field(TestRecipient; TestRecipient)
                {
                    ApplicationArea = All;
                    Caption = 'Test Recipient';
                    Editable = false;
                    ToolTip = 'Specifies the recipients used by the test mail action.';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(SendTestMail)
            {
                ApplicationArea = All;
                Caption = 'Send Test Mail';
                Image = Email;
                ToolTip = 'Sends a test mail to the fixed test recipient.';

                trigger OnAction()
                var
                    JobQueueWarningMgt: Codeunit "KCX Job Queue Warning Mgt.";
                begin
                    JobQueueWarningMgt.SendTestMail();
                    Message(TestMailSentMsg);
                end;
            }
        }
    }

    trigger OnOpenPage()
    var
        Setup: Record "KCX Job Queue Warning Setup";
    begin
        if Setup.Get('SETUP') then
            TestRecipient := Setup."Notification Emails";
    end;

    var
        TestRecipient: Text[250];
        TestMailSentMsg: Label 'The test mail has been sent.';
}
