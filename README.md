# Mi modificación del Symfony2 autocomplete


The same autocomplete of KnpLabs but with a wrapper over `sf2` alias.


## install

The same, I use one folder named ~/code for all my little tools... so:

	cd ~/code && git clone https://github.com/guilu/symfony2-autocomplete.git


and then in one of your dotfiles: .bashrc or .bash_profile or whatever:

	if [ -e ~/code/symfony2-autocomplete/sf2-autocomplete.sh ]; then
        . ~/code//symfony2-autocomplete/sf2-autocomplete.sh
    fi
 
# sf2 autocomplete


Once you restart your bash, you should be able to autocomplete in a Symfony2 project:

    sf2 ca[TAB]
