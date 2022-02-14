resource "aws_flow_log" "sandbox_vpc_flow_log" {
  iam_role_arn    = aws_iam_role.sandbox_vpc_flow_logs.arn
  log_destination = aws_cloudwatch_log_group.sandbox_vpc_flow_logs.arn
  traffic_type    = "ALL"
  vpc_id          = aws_vpc.sandbox_vpc.id
}

resource "aws_cloudwatch_log_group" "sandbox_vpc_flow_logs" {
  name              = "generic_sandbox_vpc_flow_logs"
  // TODO: change retention period, when move to production
  retention_in_days = 7
}

resource "aws_iam_role" "sandbox_vpc_flow_logs" {
  name = "generic_sandbox_vpc_flow_logs"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "vpc-flow-logs.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "sandbox_vpc_flow_logs" {
  name = "generic_sandbox_vpc_flow_logs"
  role = aws_iam_role.sandbox_vpc_flow_logs.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogGroups",
        "logs:DescribeLogStreams"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}