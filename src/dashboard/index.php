<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Dashboard</title>
  <link rel="stylesheet" type="text/css" href="css/foundation.min.css">
  <link rel="stylesheet" type="text/css" href="css/foundation-icons/foundation-icons.css">
  <link rel="stylesheet" type="text/css" href="css/app.css">
</head>
<body class="bgi">
  <div class="row text-center top-pad">

    <h1 class="success bottom-pad">Dashboard</h1>
    <a href="adminer.php"class="large button">Go to <span data-tooltip aria-haspopup="true" class="has-tip left" data-disable-hover='false' tabindex=3 title="Adminer is a super lightweight alternative to PhpMyAdmin">Adminer</span></a>

    <a href="phpinfo.php" class="large button">Go to <span data-tooltip aria-haspopup="true" class="has-tip right" data-disable-hover='false' tabindex=3 title="Phpinfo lets you see what your current PHP configuration is">PHPInfo</span></a>
  </div>
  <hr>
  <div class="row top-pad">
    <div class="small-10 small-centered columns callout">
      <h4 class="bottom-pad text-center">Instructions</h4>
      Please clone your repos into the <code>src</code> folder.
      In order to add new vhosts, please follow this procedure:<br><br>
      <ul class="small-6 columns small-centered text-left">
        <li>Open the <code>install.sh</code> script located at your install path root</li>
        <li>Copy and paste the default vhost entry I provided and edit it to your needs</li>
        <li>Add an entry for your vhost in the <code>Enable the sites</code> section of the file</li>
        <li>run <code>vagrant provision</code></li>
      </ul>
      You can also of course create your own vhosts manually inside the VM, but be aware that running <code>vagrant provision</code> without having them sourced in <code>install.sh</code> <strong>will</strong> delete them.<br>
      <br>Please remember to add your vhosts to your host's machine <code>/etc/hosts</code> file.<br>
    </div>
  </div>
  <div class="row">
    <table class="small-10 small-centered columns text-center">
      <caption>Credentials and Documentation</caption>
      <thead>
        <tr>
          <th class="text-center" width="200">MySQL Credentials</th>
          <th class="text-center" width="200">SSH Credentials</th>
          <th class="text-center" width="200">Tools documentation</th>
        </tr>
      </thead>
      <tbody>
        <tr>
          <td><strong>user: </strong><code>root</code></td>
          <td><strong>user: </strong><code>vagrant</code></td>
          <td><a target="_blank" href="//docs.vagrantup.com/v2/">Vagrant</a></td>
        </tr>
        <tr>
          <td><strong>pass: </strong><code>root</code></td>
          <td><strong>ssh key path:</strong><br><code>[INSTALL PATH]/.vagrant/machines/default/virtualbox/private_key</code></td>
          <td><a target="_blank" href="//www.virtualbox.org/wiki/Documentation">VirtualBox</a></td>
        </tr>
        <tr>
          <td><strong>port: </strong><code>3306</code></td>
          <td><strong>port: </strong><code>2222</code></td>
          <td><a target="_blank" href="//www.adminer.org/en/">Adminer</a></td>
        </tr>
        <tr>
          <td><strong>host: </strong><code>127.0.0.1</code></td>
          <td><strong>host: </strong><code>127.0.0.1</code></td>
          <td><a target="_blank" href="//php.net/">PHP</a></td>
        </tr>
      </tbody>
    </table>
  </div>
</div>
<div class="row text-center top-pad">
  <div class="subheader callout small-4 columns small-centered">
    Need help ? <a target="_blank" href="//github.com/ladydascalie">Find me on Github <i class="fi-social-github"></i></a><br>Contributions welcome!
  </div>
  <div class="">
    Made by Benjamin Cable with <i class="fi-heart"></i>
  </div>
</body>
<script src="js/vendor/jquery.min.js"></script>
<script src="js/foundation.min.js"></script>
<script src="js/app.js"></script>
</html>
