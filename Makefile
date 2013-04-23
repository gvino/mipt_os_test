############################################################################
# Makefile to build and run simple OS on VirtualBox (tm) Virtual Machines. #
# VERSION 0.0.2                                                            #
# AUTHOR  George A. Vinogradov <g-vino@yandex.ru>, <g.vinogradov@itima.ru> #
# Please feel free to send feedback :)                                     #
############################################################################

VM_NAME = mipt_os_test

IMAGE_NAME = floppy
IMAGE_PATH = $(realpath $(IMAGE_NAME).img)
BIN = os.bin
SRC = os

ASMC = nasm
ASMC_FLAGS = -fbin

VB_CONTROL = VBoxManage
VB_CONTROL_ERR = ./log

# It's kind of Unix magic. Piping stderr to next command:
# cmd1 3>&1 1>&2 2>&3 3>&- | cmd2

T_LOG_PREFIX = date +[%d.%m.%Y\ -\ %T.%s]				# Formatted date

# Next code line-by-line:
# 		Pipe stderr to sed
# 		Add prefix to each line of input
T_ERR_LOGGED = 3>&1 1>&2 2>&3 3>&- | 				  \
			   sed 's/^/'"`$(T_LOG_PREFIX)`"' /'      \
			   >> $(VB_CONTROL_ERR)

#TODO refactor to remove repetitions

# Next code line-by-line:
# 		Add media to $(VM_NAME)
# 		Media is first FDD in VM
# 		Path to image
# 		Log errors
VM_ADDMEDIA = ($(VB_CONTROL) storageattach $(VM_NAME) \
			   --storagectl Floppy --device 0 		  \
			   --medium $(IMAGE_PATH) 				  \
			   $(T_ERR_LOGGED)						  \
			   && echo "Media successfully added")	  \
			   || echo "Cannot attach media"

VM_START 	= ($(VB_CONTROL) startvm $(VM_NAME)	  	  \
		       $(T_ERR_LOGGED))

VM_STOP 	= ($(VB_CONTROL) controlvm $(VM_NAME)	  \
			   poweroff								  \
		   	   $(T_ERR_LOGGED)						  \
		   	   && echo "VM successfully stopped")	  \
		   	   || echo "Couldn't stop VM. Is it running? (Check logfile)"

VM_RESTART = ($(VB_CONTROL) controlvm $(VM_NAME)	  \
			  reset									  \
			  $(T_ERR_LOGGED)						  \
			  && echo "Successfully restarted...")


all: img

$(BIN): $(SRC).asm
	$(ASMC) $(ASMC_FLAGS) -o $@ $<

$(IMAGE_NAME).img:
	dd bs=512 count=2880 if=/dev/zero of=$@

img: $(IMAGE_NAME).img $(BIN)
	dd bs=512 count=1 if=$(BIN) of=$<

clean:
	@$(VM_STOP)
	rm -rf $(BIN)
	rm -rf $(IMAGE_NAME).img

#TODO add VM setup

vm_load: img
	@$(VM_ADDMEDIA)
	@$(VM_START) || $(VM_RESTART) || echo "Something went wrong..."

vm_start:
	@$(VM_START) || echo "Already started"
