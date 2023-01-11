# ALB Security Group : Edit to restrict acess to the application
resource "aws_security_group" "lb" {
    name        = "abhi-load-balancer-security-group"
    description = "controls acess to the ALB"
    vpc_id      = aws_vpc.main.id

    ingress {
        protocol    = "tcp"
        from_port   = var.app_port
        to_port     = var.app_port
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        protocol    = "-1"
        from_port   = 0
        to_port     = 0
        cidr_blocks = ["0.0.0.0/0"]
   }
}

# Traffic to the ECS cluster should only come from the ALB
resource "aws_security_group" "ecs_tasks" {
    name        = "abhi-ecs-tasks-security-group"
    description = "allow inbound acess from ALB only"
    vpc_id      = aws_vpc.main.id

    ingress {
        protocol        = "tcp"
        from_port       = var.app_port
        to_port         = var.app_port
        security_groups = [aws_security_group.lb.id]
    }
    egress {
        protocol    = "-1"
        from_port   = 0
        to_port     = 0
        cidr_blocks = ["0.0.0.0/0"]
   }
}