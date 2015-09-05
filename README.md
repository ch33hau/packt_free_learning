# packt_free_learning
Shell script to retrieve free book from Packt.

First time login will save your credential to $HOME/.packt file in base64($username:$password) format.
Subsequently it will retrieve your credential from file.

Default download location is $HOME/packt/.

### Usage

    bash -c "$(curl -s https://raw.githubusercontent.com/ch33hau/packt_free_learning/master/packtpub-free-learning.sh)"

If you prefer not to download the claimed free book (eg, running cronjob at server):

    bash -c "$(PACKT_DOWNLOAD=N curl -s https://raw.githubusercontent.com/ch33hau/packt_free_learning/master/packtpub-free-learning.sh)"
