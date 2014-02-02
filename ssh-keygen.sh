#!/usr/bin/env bash

#For https://galileo.mailstation.de/?p=225

email="rofrol@gmail.com"
hostname="galileo.mailstation.de"
hostalias="$hostname"
keypath="$HOME/.ssh/exherbo_rsa"

# rsa is faster in decryption then dsa http://security.stackexchange.com/questions/5096/rsa-vs-dsa-for-ssh-authentication-keys

ssh-keygen -t rsa -C $email -f $keypath

# http://superuser.com/questions/232373/tell-git-which-private-key-to-use

# Please note the "IdentitiesOnly yes" directive. This config line is very important to make sure that SSH does actually use the identity file you indicate. Otherwise your configuration may be overridden by an SSH agent or other things on the system.
# http://www.freshblurbs.com/blog/2013/06/22/github-multiple-ssh-keys.html

# VerifyHostKeyDNS yes ? https://devcenter.heroku.com/articles/git-repository-ssh-fingerprints

if [ $? -eq 0 ]; then
cat >> ~/.ssh/config <<EOF
Host $hostalias
        Hostname $hostname
        User git
	IdentitiesOnly yes
        IdentityFile $keypath
EOF
fi

# http://stackoverflow.com/questions/5130968/how-can-i-copy-the-output-of-a-command-directly-into-my-clipboard
if command -v xclip 1>/dev/null; then
	cat "$keypath".pub | xclip -i -selection clipboard
	[ $? -eq 0 ] && echo "public key copied to X clipboard"
fi

cat >> $HOME/.ssh/known_hosts <<EOF
[galileo.mailstation.de]:29418 ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCzlbhJAuLR/9S1Y31TAaVRNOgYV6xbxK+vJ1ZDAISCSVJ+RKWp+ptnzRrwYwRCfEl7DryhziHa/BAxTktt72Mat1z3pNwvcElzQ9hsl3FkWkx7TQIZNeC5MFD+aBIMTr002/jWXca8Vg2StxODNasg4HbSS/QVXJjyMAg9bCwZucgC19mnhI3r3Qc9/KfQs7ZKFgv+XVUeajRnoAGJgRfRkU4opCwW8yjE7K+qDni5bat54DqN1dPdCRuqYeqqjLdZctLq2A8LY08+Ubz9IJdMMxGit7A1TlXWp9kM/mAGJFO5AFp16MHJq/QtjKisyCfHsgI0Y1GkGlwegNdwbvaN

[galileo.mailstation.de]:29418 ssh-dss AAAAB3NzaC1kc3MAAACBAI7jPTKBSj1rUHPXarh5YCMX5xuc5AgbRmFHbyU+apys7cSoJWx17+xOzcFT6Fbf0NPGwmnB2Hf7XQ91Mj6klHsd7RiSa92PUx2bVdPSIPALfF83iZucFBw/GqkUw3Q3pIFFnOWhq6kiVkjTOUd3S3QwrkaDfbsvhX4MKmGmAfjHAAAAFQCcDMqybkq3e3FW5SvW+bKLOoT0RwAAAIBkADOGEwyT9BjU5hVjPYyYPnJ0AWYk5QMG3hZOdQvSbmXXJHBPwiVWfg6KBxhOg7EIN9XEBCgUFMVDOdoIPBSum6etbAFPA9uq4+VA+9y9jQiSH4ywDk9Q1kc1F4DSObnUR1ZyxePvJT5jGA5Q6zbmd++fCbA7MDySV/tKftKQZgAAAIA1BUT1SrvVyhsJ+vHH14RklsBjzY/KjDyPgOnHuPQHQtYSNGhjOsI/CQKauP1eDjbuQZ4Dj1Oej4HlbKhWuIjXxxLMEF7Vc7pPogqoz/dhXCqPvoRc9UB9L9lhzanN73H/ErH9oyOmR1qpaG+1nmyVP1+7YofmOcbWc5ZkuEj2sg==
EOF

# http://superuser.com/questions/529132/how-do-i-extract-fingerprints-from-ssh-known-hosts
ssh-keygen -l -f $HOME/.ssh/known_hosts

# change remote url if needed
# git remote set-url origin git@${hostalias}:rofrol/foo.git
