# ALB
resource "aws_lb" "emistest_alb" {
    name               = "emistest-alb"
    internal           = false
    load_balancer_type = "application"
    subnets             = data.terraform_remote_state.main_tf.outputs.emistest_vpc_public_subnets
}

resource "aws_lb_listener" "emistest_alb_listner" {
    load_balancer_arn = aws_lb.emistest_alb.arn
    port              = "80"
    protocol          = "HTTP"

    default_action {
        type             = "forward"
        target_group_arn = aws_lb_target_group.emistest_alb_target_group.arn
    }
}

resource "aws_lb_target_group" "emistest_alb_target_group" {
  name        = "emistest-alb-target-group"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = data.terraform_remote_state.main_tf.outputs.emistest_vpc_id
}
