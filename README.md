# Reads Google Sheet for appointment details and sends SMS reminder with Twilio

This robot reads details (name, details and mobile number) from a given Google Sheet, and sends an SMS reminder for each row using Twilio, using `RPA.Notify` library. The main purpose of the demo is to demonstrate the simplicity of SMS messaging from a robot.

## Setting up required connections and secrets

This example uses the Vault in Control Room to store secrets that are required to access your Google Sheet for read and write, as well as the Twilio credentials. Next chapter walk you through the setup.

### Google Sheets setup

Start by copying the Google Sheet for the demo purposes to yourself. Here's a [sample](https://docs.google.com/spreadsheets/d/1QFvDR5GnGAI_TQL5uhmgkAiLiDsNc7cwUrPpDF2PUp0/edit#gid=0). Make sure to use the same names for the two sheets: `Appt` for appointments and `Log` for the send log, and with the exact same column names (unless you want to edit the robot code accordingly).

Then, follow Google Sheet Service account setup guide from [here](https://robocorp.com/docs/development-guide/google-sheets/interacting-with-google-sheets#storing-the-credentials-in-control-room-vault). This example uses vault named `Google` and a key named `service_account`.

![vault-google](https://user-images.githubusercontent.com/40179958/173300620-4b2d9f3e-c9b7-4152-ba11-e6c133e2886b.png)

Also add in the same vault your `sheet_id` as a key, and get the value from the URL of your Google sheet. It's the part of the URL that looks like this:

![sheet-id](https://user-images.githubusercontent.com/40179958/173300650-531cc517-08ed-46b6-bff2-f34ca4b4a1a8.png)

### Twilio setup

Twilio is used to send the SMS messages in this example. Unless you already have an account, you can create one for free at [Twilio.com](https://www.twilio.com/try-twilio).

Next, find the account SID, Auth Token and your Twilio "from" number from the account details page, and add them to a Vault named `Twilio` with key names `account_sid`, `token` and `number_from`.

![twilio-details](https://user-images.githubusercontent.com/40179958/173300696-f268811f-06b4-4500-ab7f-827dc4a41795.png)
![twilio-vault](https://user-images.githubusercontent.com/40179958/173300708-336c7cbe-e62b-4377-92f5-9b9960590a98.png)

### Connect VS Code with Control Room

Unless you created the robot already in the Control Room, that needs to be done next. Follow the guide [here](https://robocorp.com/docs/development-guide/control-room/configuring-robots).

Once the robot is configured in the Control Room and you have the code open in VS Code, it's very handy to use the Mark the Monkey tab to link your development environment with the Control Room, as well as to connect with the Vault.

![vs-code](https://user-images.githubusercontent.com/40179958/173300728-b9f2e079-b592-4bed-8abc-7485937a7075.png)

Good to go! Have fun and send us feedback! <3
