output "user_passwords" {
    
    value = {
        for user,profile in aws_iam_user_login_profile.users : user => "Password created user must rest on the first login "
    }
    sensitive = true
}