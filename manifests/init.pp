# == Class: eclipse
#
# Base installation of eclipse jee
#
# === Parameters
#
# Document parameters here.
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*ensure*]
#  default 'present'
#  'present'|'absent' : Install o delete eclipse jee
# [*version*]
#  default 'R'
#  '1'|'2'|'R' :  Permits download all possible versions. R is the last version.
# [*release*]
#  default neon (last version known)  
#  you can use all known distributions, actual or future versions include kepler, luna, etc.
# [*mirror*]
#  default : 'http://ftp.osuosl.org/pub/eclipse'
#  You can set faster mirror
# [destination_path]
#  default /usr/local/
#  final path will be /usr/local/eclipse 
# [*user*]
#  default vagrant 
#  member user of eclipse (unused) new funcionality.
#
# === Examples
#
# class { eclipse:
#  ensure  => 'present',
#  version => 'R',
#  release => 'neon',
# }
#
# === Authors
#
# Author kaneproject 
#
# === Copyright
#
# Copyright 2016 kane_project
#
class eclipse(
  $ensure               = 'present',
  $version      	= 'R',
  $release      	= 'neon',
  $mirror       	= 'http://ftp.osuosl.org/pub/eclipse',
  $destination_path	= '/usr/local',
  $user			= 'vagrant',
)
 {
   include ::archive
   ensure_resource('class', 'stdlib')
   
   notice ("Eclipse loaded with params: ensure=>${ensure} version=>${version} release=>${release} mirror=${mirror}")
   
   if $version !~ /(1|2|R)/ {
    fail('Eclipse Version must be either 1, 2 or R.')
   }
   case $::kernel {
    'Linux' : {
      $os = 'linux'
      $destination_dir = '/tmp/'
    }
    default : {
      fail ( "unsupported platform ${::kernel}" ) }
   }
   notice ("Destination dir: ${destination_dir} in OS: ${os}")
   $file_name = "eclipse-jee-${release}-${version}-linux-gtk-x86_64.tar.gz"
   $destination = "${destination_dir}${file_name}"
   notice ("Destination is ${destination}")
   $install_command = "tar xf ${destination} -C ${destination_path}"
   notice ("Install command: ${install_command}")
   archive { $destination :
       ensure       => present,
       source       => "${mirror}/technology/epp/downloads/release/${release}/${version}/${file_name}",
       cleanup      => false,
       extract_path => '/tmp',
   }
   case $::kernel {
        'Linux' : {
          exec { "Install Eclpse jee ${release}" :
            path    => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
            command => $install_command,
            creates => "${destination_path}/eclipse",
          }
        }
        default : {
          fail ("unsupported platform ${::kernel}")
        }
     }
}
