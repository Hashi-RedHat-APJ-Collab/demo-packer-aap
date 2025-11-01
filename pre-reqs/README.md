# AAP Pre-reqs

At the end state, the following environment variables must be set to deploy AAP (example values provided below). This document provides screenshots to show how each of these values are retrieved.

```bash
export RHN_USERNAME="glennchia-hashi"
export RHN_PASSWORD="some_password"
export RHSM_ALLOCATION_UUID="7f4075b9-38ac-46e3-986d-bf481d1853be" #subscription allocation uuid https://access.redhat.com/management/subscription_allocations
export RHSM_OFFLINE_TOKEN="some_offline_token" #subscription offline token https://access.redhat.com/management/api expires with 30 days inactivity
export RHN_REGISTRY_SVC="16723312|svc-registry" #registry service account https://access.redhat.com/terms-based-registry/
export RHN_REGISTRY_TOKEN="ey---------"
export AAP_ADMIN_PASSWORD="Hashi123!" #Ansible Automation Platform admin password. Set your own password.
export HUB_OFFLINE_TOKEN="ey..." #Automation Hub offline token https://console.redhat.com/ansible/automation-hub/token expires with 30 days inactivity
```

# 1. Partner connect

Already have a RedHat account. In the screenshot below, the username is `glennchia-hashi`. This maps to `RHN_USERNAME`. Use the same password as the one used to login.

![redhat profile](./docs/01-partner-connect/01-redhat-profile.png)

Sign up for Red Hat Partner Connect - https://connect.redhat.com/partner-apps/subscriptions

Accept terms and conditions

![partner terms](./docs/01-partner-connect/02-partner-terms.png)

Agree to terms and Submit

![terms and conditions](./docs/01-partner-connect/03-terms-and-conditions.png)

Choose `Demo and/or POC` and choose `Review Terms and Conditions`

![review terms and conditions](./docs/01-partner-connect/04-review-terms-and-conditions.png)

Agree to Partner Subscription Terms

![partner subscription terms](./docs/01-partner-connect/05-partner-subscription-terms.png)

This leads back to the same page as before. Choose `Demo and/or POC` and choose `Review Terms and Conditions`

![request partner subscription](./docs/01-partner-connect/06-request-partner-subscription.png)

Confirmation page that the `Red Hat Partner Subscription has been activated`

![partner subscription activated](./docs/01-partner-connect/07-partner-subscription-activated.png)

Refreshing the page shows the `Partner Subscription Already Activated`

![subscription already activated](./docs/01-partner-connect/08-subscription-already-activated.png)

Viewing current partner subscriptions shows the subscription start and end date

![subscription details](./docs/01-partner-connect/09-subscription-details.png)

# 2. Create a new subscription allocation

> [!NOTE]
> After signing up for Partner Connect, you may need to wait a few minutes before creating a new subscription allocation. If you encounter errors, please wait and try again as permissions need time to fully activate.

Enter https://access.redhat.com/management/subscription_allocations and choose `Create New subscription allocation`

![create new subscription allocation](./docs/02-subscription-allocation/01-create-new-subscription-allocation.png)

Choose the latest Satellite version for `Type`

![type](./docs/02-subscription-allocation/02-type.png)

Details filled in for `Create a New subscription allocation`

![create new subscription allocation filled](./docs/02-subscription-allocation/03-create-new-subscription-allocation-filled.png)

Subscription allocation details. `UUID` is used for `RHSM_ALLOCATION_UUID`.

![subscription allocation details](./docs/02-subscription-allocation/04-subscription-allocation-details.png)

# 3. Offline token generation

Enter https://access.redhat.com/management/api and choose `GENERATE TOKEN`

![generate token](./docs/03-offline-token/01-generate-token.png)

Copy the offline token. This is used for `RHSM_OFFLINE_TOKEN`

![copy token](./docs/03-offline-token/02-copy-token.png)

> [!WARNING]  
> This token expires after 30 days of inactivity. Generate a new token if it has been 30 days or more since your last build.

# 4. Registry Service Account

Enter https://access.redhat.com/terms-based-registry/ and choose `New Service Account`

![registry service accounts](./docs/04-registry-svc/01-registry-service-accounts.png)

Enter a registry name. Take note of the number and name on this page. This is used for `RHN_REGISTRY_SVC`. The value of the `RHN_REGISTRY_SVC` environment variable follows this format: `<replace-with-number>|<replace-with-name>`. For example: `11112222|svc-registry`.

![registry name](./docs/04-registry-svc/02-registry-name.png)

Registry service account created. Click the account name

![registry service account created](./docs/04-registry-svc/03-registry-service-account-created.png)

This displays the token information. Copy this token. This is used for `RHN_REGISTRY_TOKEN`

![token information](./docs/04-registry-svc/04-token-information.png)

# 5. Hub offline token

Enter https://console.redhat.com/ansible/automation-hub/token and under `Offline token` choose `Load token`

![offline token load token](./docs/05-hub-token/01-offline-token-load-token.png)

This displays the offline token. Copy the offline token. This is used for `HUB_OFFLINE_TOKEN`

![offline token](./docs/05-hub-token/02-offline-token.png)

> [!WARNING]  
> This token expires after 30 days of inactivity. Generate a new token if it has been 30 days or more since your last build.
