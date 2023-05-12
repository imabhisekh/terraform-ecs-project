resource "aws_ecs_cluster" "main" {
    name = "abhi-cluster"
}

data "template_file" "cb_app" {
    template = file ("./template/ecs/cb_app.json.tpl")

    vars = {
        app_image      = var.app_image
        app_port       = var.app_port
        fargate_cpu    = var.fargate_cpu
        fargate_memory = var.fargate_memory
        aws-region     = var.aws-region
        tag            = var.tag
    }
}

resource "aws_ecs_task_definition" "app" {
    family                   = "testing my repo"
    execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
    network_mode             = "awsvpc"
    requires_compatibilities = ["FARGATE"]
    cpu                      = var.fargate_cpu
    memory                   = var.fargate_memory
    container_definitions    = data.template_file.cb_app.rendered

}

resource "aws_ecs_service" "main" {
    name            = "i doeeeeknow1"
    cluster         = aws_ecs_cluster.main.id
    task_definition = aws_ecs_task_definition.app.arn
    desired_count   = var.app_count
    launch_type     = "FARGhh"

    network_configuration {
        security_groups  = [aws_ecs_cluster.main.id]
        subnets          = aws_subnet.private.*.id
        assign_public_ip = true
    }
  
    depends_on = [aws_alb_listener.front_end, aws_iam_role_policy_attachment.ecs_task_execution_role]
}