#!/bin/bash

#Kubernetes stack factory
#moonlitcoders@gmail.com - Ren
#automates to a great extent deployment of a Kubernetes cluster
#additional nodes can be added using the add node option after stack deployment
## turn off and disable swap on all nodes - not supported at this time




#Functions

twin_line() {
  echo "**************************************************************************************************************************************"
  echo "**************************************************************************************************************************************"
}

twin_column() {
  echo "*****                                                                                                                  *****"
}


single_line() {
  echo "**************************************************************************************************************************************"
}




function show_menu(){
    NORMAL=`echo "\033[m"`
    MENU=`echo "\033[36m"` #Blue
    NUMBER=`echo "\033[33m"` #yellow
    FGRED=`echo "\033[41m"`
    RED_TEXT=`echo "\033[31m"`
    ENTER_LINE=`echo "\033[33m"`
    clear
    echo
    echo
    echo
    echo
    echo -e "         ${MENU}**************************************    Kubernetes Cluster Builder    ********************************************${NORMAL}"
    echo -e "         ${MENU}********************************************************************************************************************${NORMAL}"
    echo -e	"         ${MENU}******                                                                                                        ******${NORMAL}"
    echo -e	"         ${MENU}******                                                                                                        ******${NORMAL}"
    echo -e	"         ${MENU}******  This script aims to automate the install/config of a Kubernetes Cluster with a master and x amount of ******${NORMAL}"
    echo -e	"         ${MENU}******  nodes. You will need to run this script with (option 2) on all hosts (master and nodes)               ******${NORMAL}"
    echo -e	"         ${MENU}******                                                                                                        ******${NORMAL}"
    echo -e	"         ${MENU}******  You will be asked about your infrastructure including: server/node hostnames/ip addresses, ssh ports, ******${NORMAL}"
    echo -e	"         ${MENU}******  in order to complete the cluster build.                                                               ******${NORMAL}"
    echo -e	"         ${MENU}******                                                                                                        ******${NORMAL}"
    echo -e	"         ${MENU}********************************************************************************************************************${NORMAL}"
    echo -e	"         ${MENU}******                                                                                                        ******${NORMAL}"
    echo -e	"         ${MENU}******                                                                                                        ******${NORMAL}"
    echo -e "         ${MENU}******${NUMBER}       1)${MENU} Check installed package dependency                                                            ******${NORMAL}"
    echo -e "         ${MENU}******${NUMBER}       2)${MENU} Install package binaries [golang, docker] (required on all hosts - Master + nodes)            ******${NORMAL}"
    echo -e "         ${MENU}******${NUMBER}       3)${MENU} Install Kubeadm Toolbox (required on all hosts - Master + nodes)                              ******${NORMAL}"
    echo -e "         ${MENU}******${NUMBER}       4)${MENU} Destroy Kubernetes cluster                                                                    ******${NORMAL}"
    echo -e "         ${MENU}******${NUMBER}       5)${MENU} Reset Kubernetes cluster (run to clean up old cluster and prep for new one)                   ******${NORMAL}"
    echo -e "         ${MENU}******${NUMBER}       6)${MENU} Deploy Kubernetes Cluster                                                                     ******${NORMAL}"
    echo -e "         ${MENU}******${NUMBER}       7)${MENU} Add a Node to existing Cluster                                                                ******${NORMAL}"
    echo -e "         ${MENU}******                                                                                                        ******${NORMAL}"
    echo -e	"         ${MENU}******                                                                                                        ******${NORMAL}"
    echo -e	"         ${MENU}******                                                                                                        ******${NORMAL}"
    echo -e "         ${MENU}********************************************************************************************************************${NORMAL}"
    echo -e "         ${MENU}********************************************************************************************************************${NORMAL}"
    echo -e "         ${ENTER_LINE}Please enter a menu option number or ${RED_TEXT}Press enter to exit. ${NORMAL}"
    read opt
}


function option_picked() {
    COLOR='\033[01;31m' # bold red
    RESET='\033[00;00m' # normal white
    MESSAGE=${@:-"${RESET}Error: No message passed"}
    echo -e "${COLOR}${MESSAGE}${RESET}"
}

function return_menu(){
  echo
  echo
	echo "Press any key to go back to Menu..."
	read -n 1
	clear
}


function check_packages(){
  echo
  echo -e "${NUMBER}    Please standby ....${NORMAL}"
  echo
  echo
  twin_line
  echo
  sudo docker version
  echo
  echo
  git version
  echo
  echo
  go version
  echo
  twin_line
  echo
  echo -e "${RED_TEXT}    If command is not found for any packages (go, docker, git), ${NORMAL}"
  echo -e "${RED_TEXT}    you will need to run the packages install in main menu option 2 ${NORMAL}"
  echo
  return_menu
  show_menu;
}


function install_package_dependency() {

  ## install and configure golang, docker 1.13+, git
  ##
  single_line
  echo -e "${RED_TEXT}***** Begin preliminary install of required dependency packages....                                  *****${NORMAL}"
  single_line
  echo
  sudo apt-get update
  single_line
  echo -e "${RED_TEXT}***** Installing docker 17.03+ if not already installed..                                            *****${NORMAL}"
  single_line
  sleep 2
  sudo apt-get install -y docker.io
  sleep 3
  sudo groupadd docker
  sudo usermod -aG docker $USER
  single_line
  echo -e "${RED_TEXT}***** Installing latest git version if not already installed..                                       *****${NORMAL}"
  single_line
  sudo apt-get install -y git
  sleep 3
  single_line
  echo -e "${RED_TEXT}***** Adding golang repo and installing latest binary                                                *****${NORMAL}"
  single_line
  sudo add-apt-repository ppa:hnakamur/golang-1.10
  sleep 2
  sudo apt update
  sleep 3
  sudo apt-get install -y golang-go golang-1.10-doc
  single_line
  echo -e "${RED_TEXT}***** Adding go binary to your .profile so it is in your PATH..                                      *****${NORMAL}"
  single_line
  sleep 2
  echo "export PATH=\$PATH:/usr/lib/go-1.10/bin" >> ~/.profile
  source ~/.profile
  clear
  sleep 2
  echo
  echo
  twin_line
  echo -e "${RED_TEXT}***** Recap of installed components:                                                                 *****${NORMAL}"
  single_line
  echo
  echo
  sleep 2
  echo "Docker Version:"
  echo
  echo
  \
  sudo docker version
  echo
  echo
  git version
  echo
  echo
  go version
  echo
  echo
  echo "Note: User that ran this configuration has been added to the docker group to remove the need to sudo any docker commands"
  echo "You should log out and back in for the changes to take effect..."
  return_menu
  show_menu;

}


function install_kubeadm_toolbox(){
echo
echo
twin_line
echo
echo -e "${RED_TEXT}    In order to build a Kubernetes cluster, the kubeadm toolbox (kubeadm, kubelet, and kubectl) will
    need to be installed and swap will need to be disabled on this machine. ${NORMAL}"
echo
echo -e "${RED_TEXT}    The next step will perform that process.. ${NORMAL}"
echo
twin_line
echo
read -r -p "Do you want to proceed with installing the Kubeadm Toolbox? [y/N]: " response
case "$response" in
    [yY][eE][sS]|[yY])
        echo
        echo "Initiating Kubeadm toolbox install - Please Wait...."
        sleep 2
        echo
        echo
        single_line
        echo -e "${RED_TEXT}***** updating & installing some dependencies (apt-transport, curl)                             *****${NORMAL}"
        single_line
        echo
        sudo apt-get update && apt-get install -y apt-transport-https curl
        sudo curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
        echo
        echo
        sleep 2
        single_line
        echo -e "${RED_TEXT}***** adding kubernetes packages to repo list......                                             *****${NORMAL}"
        single_line
        echo
        echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" > /etc/apt/sources.list.d/kubernetes.list
        echo
        single_line
        echo -e "${RED_TEXT}***** disabling swap on drive...                                                                *****${NORMAL}"
        single_line
        echo
        swapoff -a
        sleep 2
        echo
        single_line
        echo -e "${RED_TEXT}***** updating package lists from repos & installing kubeadm toolkit..                          *****${NORMAL}"
        single_line
        echo
        echo
        sudo apt-get update
        sudo apt-get install -y kubelet kubeadm kubectl
        sudo apt-mark hold kubelet kubeadm kubectl
        echo
        echo
        single_line
        echo -e "${RED_TEXT}***** Kubeadm toolkit installed!                                                                *****${NORMAL}"
        single_line
        echo
        return_menu
        show_menu;
        ;;

  *)
        echo
        echo
        echo "Cancelling Kubeadm Toolbox install..."
        sleep 2
        return_menu
        show_menu;
        ;;

esac

}

function destroy_cluster(){
echo
echo
twin_line
echo
echo -e "${RED_TEXT}    WARNING!!! your cluster will be destroyed ${NORMAL}"
echo -e "${RED_TEXT}    You will need to place this script on each node including master and run this option (4)                 ${NORMAL}"
echo -e "${RED_TEXT}    Please confirm you want to do this! ${NORMAL}"
echo
twin_line
echo

read -r -p "Are you sure you want to continue with destroying your cluster? Again, this will remove all pods [y/N]: " response
case "$response" in
    [yY][eE][sS]|[yY])

        echo
        echo
        echo "Please enter name of your node - start with your nodes first then do master last"
        echo
        read nodename1
        echo
        single_line
        echo -e "${RED_TEXT} Draining node and all resources...   ${NORMAL}"
        single_line
        sleep 2
        kubectl drain $nodename1 --delete-local-data --force --ignore-daemonsets
        sleep 2
        echo
        echo
        single_line
        echo -e "${RED_TEXT} Node is deleting...      ${NORMAL}"
        single_line
        sleep 2
        echo
        kubectl delete node $nodename1
        sleep 2
        echo
        echo
        echo
        single_line
        echo -e "${RED_TEXT} Node has been drained and deleted   ${NORMAL}"
        single_line
        #source ~/.profile
        sleep 2
        return_menu
        show_menu;
        ;;
  *)
        echo
        echo
        echo "Aborting..."
        sleep 2
        return_menu
        show_menu;
        ;;

esac

}


function reset_cluster(){
echo
echo
twin_line
echo
echo -e "${RED_TEXT}    This is the second step towards resetting your cluster, prior to deploying a new one. ${NORMAL}"
echo -e "${RED_TEXT}    You will need to place this script on each node including master and run this option (5) for each. ${NORMAL}"
echo -e "${RED_TEXT}    Please confirm you want to do this! ${NORMAL}"
echo
twin_line
echo

read -r -p "Are you sure you want to continue with resetting your cluster? Again, this will remove all current cluster
configurations [y/N]: " response
case "$response" in
    [yY][eE][sS]|[yY])

        echo
        echo
        echo "Please enter name of your node - start with your nodes first then do master last:"
        echo
        read nodename
        echo
        single_line
        echo -e "${RED_TEXT} resetting ...   ${NORMAL}"
        single_line
        echo
        sleep 2
        sudo kubeadm reset
        sleep 2
        echo
        single_line
        echo -e "${RED_TEXT} Node was reset... ${NORMAL}"
        single_line
        echo
        echo
        single_line
        echo -e "${RED_TEXT} Now deleting .kube configuration folder in your home directory..   ${NORMAL}"
        single_line
        echo
        sleep 2
        cd ~
        sudo rm -rv .kube
        rm -rv ~/heapster
        rm -v dashboard-admin.yaml
        echo
        sleep 2
        single_line
        echo -e "${RED_TEXT} Node is clean and reset - repeat with all other nodes and lastly your master node. ${NORMAL}"
        single_line
        echo
        sleep 2
        return_menu
        show_menu;
        ;;

  *)
        echo
        echo "Aborting..."
        sleep 2
        return_menu
        show_menu;
        ;;


esac

}


function deploy_cluster(){
echo
echo
twin_line
echo
echo -e "${RED_TEXT}    Welcome to the Kubernetes Cluster builder! if you reached this step, you completed the first 3 steps ${NORMAL}"
echo -e "${RED_TEXT}    which includes installing the package binaries (on all your hosts, master node included) for golang, git, and docker.${NORMAL}"
echo -e "${RED_TEXT}    And finally, installed the Kubeadm toolbox, which installs kubeadm, kubectl, and kubelet, as well on all your hosts. ${NORMAL}"
echo -e "${RED_TEXT}    This step should only be run on the host that will serve as your Master Node - DO NOT RUN THIS option on any of your
    other nodes - After completing this step on your Master, go the the next step menu option 7 to add your nodes to this master ${NORMAL}"
echo
twin_line
echo
echo
read -r -p "Please confirm that you want to continue with building your Kubernetes cluster?  [y/N]: " response
case "$response" in
    [yY][eE][sS]|[yY])

        echo
        echo
        single_line
        echo
        echo -e "${RED_TEXT} Making sure swap is disabled - this is mandatory as swap is not supported  ${NORMAL}"
        echo
        single_line
        sleep 2
        echo
        echo
        sudo cat /proc/swaps
        echo
        echo
        sudo swapoff -a
        sleep 3
        echo
        echo
        twin_line
        echo
        echo -e "${RED_TEXT}Please enter the advertise address ip in the next prompt ${NORMAL}"
        echo -e "${RED_TEXT}This can be your external ip if you plan to access your cluster from outside your network ${NORMAL}"
        echo -e "${RED_TEXT}or the local host ip to your what will be your Node Master (This should be the machine you are running this script on) ${NORMAL}"
        echo
        single_line
        echo
        echo -e "${RED_TEXT}Please enter the advertise address ip: ${NORMAL}"
        read masterIp
        sleep 2
        echo
        sudo kubeadm init --pod-network-cidr=10.244.0.0/16 --apiserver-advertise-address=$masterIp
        sleep 5
        echo
        echo
        single_line
        echo
        echo -e "${RED_TEXT} NOTE - you will not need to complete the steps above for creating the .kube configuration
        directory as it will be created for you automatically in the next step - please standby... ${NORMAL}"
        sleep 5
        echo
        echo
        single_line
        echo
        echo -e "${RED_TEXT} Creating Kubernetes config directory in ~/.kube... ${NORMAL}"
        echo
        echo
        sleep 2
        mkdir -pv $HOME/.kube
        sudo cp -rfv /etc/kubernetes/admin.conf $HOME/.kube/config
        sudo chown $(id -u):$(id -g) $HOME/.kube/config
        echo
        single_line
        echo
        echo -e "${RED_TEXT} Completing Master Node install and initializing... ${NORMAL}"
        echo
        echo
        sleep 2
        echo -e "${RED_TEXT} Please standby..... ${NORMAL}"
        sleep 3
        single_line
        echo
        echo -e "${RED_TEXT} Creating and initializing Pod network (This will deploy Calico Canal network) ${NORMAL}"
        echo -e "${RED_TEXT} Please standby..... ${NORMAL}"
        sleep 3
        echo
        echo
        ## Deploy Calico project Canal Pod network - can apply various others to work with Kubernetes cluster
        ## See documentation here - https://kubernetes.io/docs/setup/independent/create-cluster-kubeadm/#pod-network
        kubectl apply -f https://docs.projectcalico.org/v3.1/getting-started/kubernetes/installation/hosted/canal/rbac.yaml
        kubectl apply -f https://docs.projectcalico.org/v3.1/getting-started/kubernetes/installation/hosted/canal/canal.yaml
        echo
        echo
        single_line
        echo -e "${RED_TEXT} Cloning heapster to your home directory (~heapster)..... ${NORMAL}"
        echo
        sleep 3
        cd ~
        sleep 2
        ## Add Heapster packages for charts and graphs in Kubernetes Dashboard
        git clone https://github.com/kubernetes/heapster
        kubectl create -f ~/heapster/deploy/kube-config/influxdb/
        kubectl create -f ~/heapster/deploy/kube-config/rbac/heapster-rbac.yaml
        echo
        echo
        echo
        single_line
        echo -e "${RED_TEXT} Cloning Kubernetes Dashboard repo and deploying app to cluster..... ${NORMAL}"
        echo
        echo
        ## Add Dashboard packages/roles for viewing cluster infrastructure
        kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/master/src/deploy/recommended/kubernetes-dashboard.yaml
        cd ~
        git clone https://gist.github.com/05ada26c02fd09f335580ba851252cfb.git
        cd ~/05ada26c02fd09f335580ba851252cfb
        cp dashboard-admin.yaml ~/
        sudo rm -rv ~/05ada26c02fd09f335580ba851252cfb
        sleep 3
        cd ~
        kubectl apply -f dashboard-admin.yaml
        kubectl create clusterrolebinding add-on-cluster-admin --clusterrole=cluster-admin --serviceaccount=kube-system:default
        sleep 4
        echo
        single_line
        echo -e "${RED_TEXT} Getting Token secret (used for accesing dashboard) and join command to add your nodes to this master ${NORMAL}"
        echo
        echo
        sleep 3
        single_line
        echo -e "${RED_TEXT} Copy the command below, log in to each of your nodes(the ones you want to add to the cluster), switch to root (sudo su - ), ${NORMAL}"
        echo -e "${RED_TEXT} and paste the command into the terminal for each node.  ${NORMAL}"
        echo -e "${RED_TEXT} This will add the nodes to your cluster... ${NORMAL}"
        echo
        kubeadm token create --print-join-command
        echo
        echo
        echo
        echo
        return_menu
        show_menu;
        ;;

  *)
        echo
        echo "Aborting..."
        sleep 2
        return_menu
        show_menu;
        ;;


esac

}



clear
show_menu
while [ opt != '' ]
    do
    if [[ $opt = "" ]]; then
            clear;
            echo
            single_line
            echo
            echo -e "${RED_TEXT} Exit selected, quitting application...${NORMAL}"
            echo
            echo -e "${RED_TEXT} Goodbye! ${NORMAL}"
            echo
            single_line
            sleep 2
            clear;
            exit;
    else
        case $opt in

        1) clear;
        	  option_picked "Option 1 Picked, Checking for installed required packages....";
            echo
            check_packages
			      sleep 1
			      ;;

        2) clear;
            option_picked "Option 2 Picked, Begin Cluster Pre-requisite Installs/Configuration....";
            echo
            install_package_dependency
            sleep 1
            ;;



        3) clear;
            option_picked "Option 3 picked, Install Kubeadm Toolbox....";
            echo
            echo "This option needs to be run on your master + all nodes... "
            echo "Start with your master node first, then run on nodes"
            sleep 3
            install_kubeadm_toolbox
            ;;



        4)  clear;
            option_picked "Option 4 picked, Destroy Kubernetes Stack and drain all pods...";
            echo
			      echo "Stack uninstalling....."
            destroy_cluster
            sleep 1
            ;;


        5)  clear;
            option_picked "Option 5 picked, Reset Kubernetes Cluster...";
            echo
    			  echo "Resetting Cluster...."
            sleep 3
            reset_cluster
            sleep 1
            ;;

        6)  clear;
            option_picked "Option 6 picked, Deploy Kubernetes Cluster...";
            echo
            echo "Building Master-Node and starting up pods... "
            sleep 3
            deploy_cluster
            ;;

        7)  clear;
            option_picked "Option 7 picked, Add Node to existing Cluster...";
            echo
            echo "This option does not yet work.. you can join a node using the join command"
            sleep 3
            return_menu
            show_menu;
            ;;


        x)exit;
        ;;

        \n)exit;
        ;;

        *)clear;
        option_picked "Pick an option from the menu";
        show_menu;
        ;;
    esac
fi
done
