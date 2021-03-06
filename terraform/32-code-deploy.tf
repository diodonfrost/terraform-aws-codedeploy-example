resource "aws_codedeploy_app" "green" {
  compute_platform = "Server"
  name             = "asg-blue-green-example"
}

resource "aws_codedeploy_deployment_group" "green" {
  app_name               = aws_codedeploy_app.green.name
  deployment_group_name  = "green-group"
  deployment_config_name = "CodeDeployDefault.AllAtOnce"
  service_role_arn       = aws_iam_role.codedeploy.arn
  autoscaling_groups     = [aws_autoscaling_group.blue.id]

  deployment_style {
    deployment_option = "WITH_TRAFFIC_CONTROL"
    deployment_type   = "BLUE_GREEN"
  }

  load_balancer_info {
    target_group_info {
      name = aws_lb_target_group.blue.name
    }
  }

  blue_green_deployment_config {
    deployment_ready_option {
      action_on_timeout = "CONTINUE_DEPLOYMENT"
    }

    green_fleet_provisioning_option {
      action = "COPY_AUTO_SCALING_GROUP"
    }

    terminate_blue_instances_on_deployment_success {
      action                           = "TERMINATE"
      termination_wait_time_in_minutes = "15"
    }
  }
}
