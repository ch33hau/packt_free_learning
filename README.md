# packt_free_learning
Shell script to retrieve free book from Packt.

First time login will save your credential to $HOME/.packt file in base64($username:$password) format.
Subsequently it will retrieve your credential from file.

Default download location is $HOME/packt/.