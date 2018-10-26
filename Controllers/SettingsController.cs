using System;
using Microsoft.AspNetCore.Http.Features;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;
using TodoApi.Models;

namespace TodoApi.Controllers {
    [ApiController]
    [Route ("api/settings")]
    public class SettingsController : ControllerBase {
        private readonly IConfiguration configuration;
        private readonly ILogger<SettingsController> logger;

        public SettingsController (IConfiguration configuration, ILogger<SettingsController> logger) {
            this.logger = logger;
            this.configuration = configuration;
        }

        /// <summary>
        /// Gets the name of the host machine - env specific YES, secret/sensitive NO
        /// </summary>
        /// <returns>Host Name</returns>
        [HttpGet ("host", Name = "settings_host")]
        [ProducesResponseType (200)]
        [ProducesResponseType (400)]
        public ActionResult<string> GetHost () {

            var hostName = this.configuration["appHost"];

            // var machineHostName = Environment.GetEnvironmentVariable("CUMPUTERNAME") ?? Environment.GetEnvironmentVariable("HOSTNAME");
            // var machine = $"{Environment.GetEnvironmentVariable("CUMPUTERNAME")}-{Environment.GetEnvironmentVariable("HOSTNAME")}";
            var httpConnectionFeature = HttpContext.Features.Get<IHttpConnectionFeature>();
            var localIpAddress = httpConnectionFeature?.LocalIpAddress;
            var remoteIpAddress = httpConnectionFeature?.RemoteIpAddress;

            if (string.IsNullOrEmpty (hostName)) {
                return NotFound ();
            }
            return Ok ($"{hostName}-{localIpAddress}-{remoteIpAddress}" );
            //UserSettings
        }

        /// <summary>
        /// Gets the name of the environment - env specific YES, secret NO
        /// </summary>
        /// <returns>Host Name - specific for the environment</returns>
        [HttpGet ("environment", Name = "settings_environment_code")]
        [ProducesResponseType (200)]
        [ProducesResponseType (400)]
        public ActionResult<string> GetEnvironment () {

            var hostName = this.configuration["environmentCode"];

            if (string.IsNullOrEmpty (hostName)) {
                return NotFound ();
            }
            return Ok (hostName);
            //UserSettings
        }


        /// <summary>
        /// Gets the default profile settings - environment specific NO, secret NO
        /// Will be stored in the appSettings.json for all the environments
        /// </summary>
        /// <returns>default profile settings</returns>
        [HttpGet ("profile", Name = "settings_profile")]
        [ProducesResponseType (200)]
        [ProducesResponseType (400)]
        public ActionResult<UserSettings> GetProfileSettings () {

            try {
                var defaultProfileSettings = this.configuration.GetSection ("DefaultProfile").Get<ProfileSettings> ();
                if (defaultProfileSettings == null) {
                    return NotFound ();
                }

                return Ok (defaultProfileSettings);
            } catch (Exception e) {
                //log the exception
                this.logger.LogError (e.Message);
                return StatusCode (500);

            }

        }




        /// <summary>
        /// MaxItems value - environment specific YES, secret NO -> will be stored in appSettings.json and will be overridden by the value in the Azure Application Settings
        /// </summary>
        /// <returns></returns>
        [HttpGet ("maxItems", Name = "settings_max_items")]
        [ProducesResponseType (200)]
        [ProducesResponseType (400)]
        public ActionResult<UserSettings> GetMaxItems () {

            try {
                var userSettings = this.configuration["maxItems"];
                if (userSettings == null) {
                    return NotFound ();
                }

                return Ok (userSettings);
            } catch (Exception e) {
                //log the exception
                this.logger.LogError (e.Message);
                return StatusCode (500);

            }

        }

        /// <summary>
        /// SqlPassword - environment specific - YES, secret/sensitive YES
        /// Will be stored in the environment specific keyvault instance d-vault or q-vault
        /// </summary>
        /// <returns></returns>
        [HttpGet ("sql-password", Name = "sql_password")]
        [ProducesResponseType (200)]
        [ProducesResponseType (400)]
        public ActionResult<UserSettings> GetSqlPassword () {

            try {
                var userSettings = this.configuration["SqlPassword"];
                if (userSettings == null) {
                    return NotFound ();
                }

                return Ok (userSettings);
            } catch (Exception e) {
                //log the exception
                this.logger.LogError (e.Message);
                return StatusCode (500);

            }

        }

        [HttpGet ("client-profile", Name = "client_profile")]
        [ProducesResponseType (200)]
        [ProducesResponseType (400)]
        public ActionResult<UserSettings> GetClientInfo () {

            try {

                var clientProfile = this.configuration.GetSection ("client").Get<ClientProfile> ();

                if (clientProfile == null) {
                    return NotFound ();
                }

                return Ok (clientProfile);
            } catch (Exception e) {
                //log the exception
                this.logger.LogError (e.Message);
                return StatusCode (500);

            }

        }

        /// <summary>
        /// Gets the credentials to be used for connecting with an external service
        /// Environment Specific YES, sensitive YES
        /// Will be stored in the corresponding environemnt keyvaults
        /// </summary>
        /// <returns></returns>
        [HttpGet ("service-subscription", Name = "service_subscription")]
        [ProducesResponseType (200)]
        [ProducesResponseType (400)]
        public ActionResult<UserSettings> GetServiceProviderSettings () {

            try {

                var serviceSubscription = this.configuration.GetSection ("ServiceSubscription").Get<ServiceSubscription> ();

                if (serviceSubscription == null) {
                    return NotFound ();
                }

                return Ok (serviceSubscription);
            } catch (Exception e) {
                //log the exception
                this.logger.LogError (e.Message);
                return StatusCode (500);

            }

        }


    }
}