# /etc/bash.bashrc
# Global Function List

# function for finding used ports in ranges
used_ports()
{
	set -exuo pipefail 
	#set -o errexit 
	#set -o nounset
	local exit_code=0 # 1: missing parameters; 2: invalid inputs
	local parms_num_req=3 # required input parameters
	
	usage()
	{
		printf "\$1: start of range:=	4 e.g.\n"
		printf "\$2: end of range:=	7 e.g.\n"
		printf "\$3: digit range:=	2 e.g.\n"
		printf "valid inputs for \$1 and \$2 are:\n"
		printf "\t0 to 9\n"
		printf "valid input for \$3 are:\n"
	        printf "\t1 to 5\n"
		exit_code=1	
		return 1
	}
	# test if all required parameters are provided
	if [ "$#" -ne "$parms_num_req" ] ; then
		printf "\n$parms_num_req parameters are required.\n"
		usage		
	fi

	# assign variables	
	local range_start=$1
	local range_end=$2
	local digit_range=$3

	if [ "$exit_code" -eq 0 ] ; then
		local valid_start_end=({0..9})
		local valid_digits=({1..5})

		if  [[ "$range_start" =~ ${valid_start_end[@]:0} ]] ; then
			allgood=true	
		else
			printf "\nInvalid input for start range\n"
			usage
		fi
		
		if  [[ "$range_end" =~ ${valid_start_end[@]:0} ]] ; then
			printf "\nInvalid input for end range\n"
			usage
		fi

		if  [[ "$digit_range" =~ ${valid_digits[@]:0} ]] ; then
			printf "\nInvalid input for start range\n"
			usage
		fi
	fi
	if [ "$exit_code" -eq 0 ] ; then
		netstat -tulpn | egrep --color=auto "(^|:)[$1-$2][0-9]{$3}"
	fi
return 0
}
