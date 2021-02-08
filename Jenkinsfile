/*
This Jenkinsfile will run the steps required to update route53 with the right
SPF records.

It will run on a regular basis based on the cron triggers below.

In order to modify the spf records, visit the Terraform route53 configuration
which is currently here: https://github.com/mention-me/Terraform/blob/master/Global/route53/mention-me.com.tf

And to add/modify domains, adjust the value of spf-orig.mention-me.com
*/
pipeline {
	agent { label 'master' }

	triggers {
		cron('H */2 * * *')
	}

	stages {
		stage('begin') {
			steps {
				sh '''
cat > ~/.spf-toolsrc <<EOF
DOMAIN=mention-me.com
ORIG_SPF=spf-orig.mention-me.com
DESPF_SKIP_DOMAINS=
DNS_TIMEOUT=5
DNS_SERVER=
EOF
				'''
			}
		}

		stage('update') {
			steps {
				// The ZZLU8Z239WBCK is the hosted zone for route53.
				sh './despf.sh | ./simplify.sh | ./mkblocks.sh | ./route53.sh ZZLU8Z239WBCK'
			}
		}

		stage('compare') {
			steps {
				// compare.sh will fail if the DNS records are different
				sh '''
					./compare.sh
				'''
			}
		}
	}

    post {
        always {
            sendNotifications currentBuild.result
        }
    }
}

/**
* Send notifications based on build status string
*
* Borrowed from: https://jenkins.io/blog/2017/02/15/declarative-notifications/
*/
def sendNotifications(String buildStatus = 'STARTED') {
    def branch = "${env.BRANCH_NAME}"

    if (! (branch ==~ /master|development|release-.*/)) {
        return
    }

    // build status of null means successful
    buildStatus = buildStatus ?: 'SUCCESS'

    // Default values
    def colorName = 'RED'
    def colorCode = '#FF0000'
    def subject = "${buildStatus}: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'"
    def summary = "${subject} (${env.BUILD_URL})"

    // We only care about failure. Skip anything else.
    if (buildStatus == 'STARTED' || buildStatus == 'NOT_BUILT' || buildStatus == 'SUCCESS') {
        return
    }

    color = 'RED'
    colorCode = '#FF0000'

    // Send notifications
    slackSend (channel: '#engineering-bots', color: colorCode, message: summary)
}
