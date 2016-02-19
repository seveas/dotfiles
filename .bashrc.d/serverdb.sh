if [ -e /usr/local/git_tree/serverdb2/settings.py ]; then
    export PYTHONPATH="/usr/local/git_tree:$PYTHONPATH"
    if [ -e /usr/local/git_tree/django-serverdb ]; then
        export PYTHONPATH="/usr/local/git_tree/django-serverdb:$PYTHONPATH"
    fi
    export DJANGO_SETTINGS_MODULE=serverdb2.settings
fi
