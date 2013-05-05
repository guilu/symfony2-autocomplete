#!bash
#
# bash completion support for symfony2 console
#
# Copyright (C) 2011 Matthieu Bontemps <matthieu@knplabs.com>
# Distributed under the GNU General Public License, version 2.0.

_console()
{
    local cur prev script
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    script="${COMP_WORDS[0]}"

    if [[ ${cur} == -* ]] ; then
        PHP=$(cat <<'HEREDOC'
array_shift($argv);
$script = array_shift($argv);
$command = '';
foreach ($argv as $v) {
    if (0 !== strpos($v, '-')) {
        $command = $v;
        break;
    }
}

$xmlHelp = shell_exec($script.' help --xml '.$command);
$options = array();
if (!$xml = @simplexml_load_string($xmlHelp)) {
    exit(0);
}
foreach ($xml->xpath('/command/options/option') as $option) {
    $options[] = (string) $option['name'];
}

echo implode(' ', $options);
HEREDOC
)

        args=$(printf "%s " "${COMP_WORDS[@]}")
        options=$($(which php) -r "$PHP" ${args});
        COMPREPLY=($(compgen -W "${options}" -- ${cur}))

        return 0
    fi

    commands=$(${script} list --raw | sed -E 's/(([^ ]+ )).*/\1/')
    COMPREPLY=($(compgen -W "${commands}" -- ${cur}))

    return 0;
}

#Ahora ya ponemos los comoandos que va a completar _console
complete -F _console console
complete -F _console console-dev
complete -F _console console-test
complete -F _console console-prod
complete -F _console console-staging
complete -F _console Symfony


#Explicación:
#La función de arriba _console() es la que proporciona el autocompletado para los comandos indicados
#para poder generar autocompletado para un alias sf2='./app/console' hay que envolver la funcion _console con otra
#personalizada que lo que haga sea llamar a la de completado correcta.

#La funcion que va a envolver el autocompletado de _console

# Author.: Ole J
# Date...: 23.03.2008
# License: Whatever

# Wraps a completion function
# make-completion-wrapper <actual completion function> <name of new func.>
#                         <command name> <list supplied arguments>
# eg.
#   alias agi='apt-get install'
#   make-completion-wrapper _apt_get _apt_get_install apt-get install
# defines a function called _apt_get_install (that's $2) that will complete
# the 'agi' alias. (complete -F _apt_get_install agi)
#
function make-completion-wrapper () {
    local function_name="$2"
    local arg_count=$(($#-3))
    local comp_function_name="$1"
    shift 2
    local function="
function $function_name {
    ((COMP_CWORD+=$arg_count))
    COMP_WORDS=( "$@" \${COMP_WORDS[@]:1} )
    "$comp_function_name"
    return 0
}"
    eval "$function"
}

# el alias que queremos autocompletar
alias sf2='./app/console'

#Ahora crear el envoltorio _console_mine 
make-completion-wrapper _console _console_mine ./app/console

# Decimos a  bash que use _console_mine para completar "sf2"
complete -o bashdefault -o default -o nospace -F _console_mine sf2

COMP_WORDBREAKS=${COMP_WORDBREAKS//:}
