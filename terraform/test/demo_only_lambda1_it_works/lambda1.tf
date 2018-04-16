resource "aws_iam_role" "iam_lambda1" {
  name = "iam_lambda1"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_policy" "policy-lambda1" {
    name        = "lambda1-policy"
    description = "Iam policy for lambda1"
    policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
        ],
        "Resource": "arn:aws:logs:*:*:*"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "attach-lambda1" {
    role       = "${aws_iam_role.iam_lambda1.name}"
    policy_arn = "${aws_iam_policy.policy-lambda1.arn}"
}

resource "aws_lambda_function" "lambda1" {
  filename         = "../../code/lambda1.zip"
  function_name    = "lambda1"
  role             = "${aws_iam_role.iam_lambda1.arn}"
  handler          = "lambda1.handler"
  source_code_hash = "${base64sha256(file("../../code/lambda1.zip"))}"
  runtime          = "nodejs6.10"

  environment {
    variables = {
      CHALLENGE_SECRET = "",
      PAGE_ACCESS_TOKEN = "",
      DYNAMO_USERS_TABLE_NAME = "",
      DYNAMO_SONGS_IN_FLIGHT_TABLE_NAME = ""
    }
  }
}