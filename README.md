# CSV-Driven AWS IAM User & Group Management

This Terraform project manages AWS IAM Users, Login Profiles, and Group Memberships dynamically using a CSV file (`users.csv`) as the single source of truth.

## Features

1. **Dynamic User Provisioning**: Parses user information from a local CSV spreadsheet (`users.csv`) containing columns: `first_name`, `last_name`, `department`, and `job_title`.
2. **Automatic Username Generation**: Generates standard corporate usernames automatically (e.g., Michael Scott becomes `mscott`).
3. **IAM Login Profiles**: Creates console access for each user with password enforcement, forcing a password reset upon their first login.
4. **Tagging Policy**: Standardizes user tagging:
   * `DisplayName`: Full user name
   * `Department`: Department code
   * `JobTitle`: Official role title
5. **Conditional Group Memberships**: Maps users to IAM Groups dynamically:
   * **Education**: Users in the `Education` department.
   * **Engineers**: Users in the `Engineering` department.
   * **Managers**: Users whose `JobTitle` contains "Manager" or "CEO".

---

## File Structure

```text
IAM-user-management/
├── data.tf            # External data sources and accounts information
├── groups.tf          # IAM groups and membership allocation rules
├── locals.tf          # Local variables to decode and process users.csv
├── main.tf            # User creation & console profile configurations
├── output.tf          # Sensitive output credentials
├── provider.tf        # AWS Provider settings
├── terraform.tf       # Version constraints and required providers
├── users.csv          # Local user registry (Source of Truth)
└── README.md          # Project documentation
```

---

## CSV File Schema (`users.csv`)

Add your user registry details inside `users.csv`. The file requires the following header row:
```csv
first_name,last_name,department,job_title
Michael,Scott,Manager,Regional Manager
Dwight,Schrute,Manager,Assistant to the Regional Manager
Jim,Halpert,Engineering,Sales Representative
```

---

## How it Works

### Username Generation
Usernames are derived using the first character of the first name appended to the last name, formatted in all lowercase:
```hcl
name = lower("${substr(each.value.first_name,0,1)}${each.value.last_name}")
```

### Dynamic Grouping
* **Managers Group Membership Rule:**
  ```hcl
  users = [
      for user in aws_iam_user.users : user.name if contains(keys(user.tags), "JobTitle") && can(regex("Manager|CEO", user.tags.JobTitle))
  ]
  ```

---

## Getting Started

1. **Configure AWS Credentials**
   Ensure your local AWS environment is configured:
   ```bash
   aws configure
   ```

2. **Initialize Terraform**
   ```bash
   terraform init
   ```

3. **Deploy the Users**
   Preview changes, then apply:
   ```bash
   terraform plan
   terraform apply
   ```

4. **Retrieve Access Credentials**
   Since password outputs are sensitive, retrieve them securely using:
   ```bash
   terraform output user_passwords
   ```

---

## Cleanup
To remove all provisioned users and memberships:
```bash
terraform destroy
```
