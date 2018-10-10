using System;
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
        /// Gets the name of the host machine
        /// </summary>
        /// <returns>Host Name</returns>
        [HttpGet ("host", Name = "settings_host")]
        [ProducesResponseType (200)]
        [ProducesResponseType (400)]
        public ActionResult<string> GetHost () {

            var hostName = this.configuration["devHost"];

            if (string.IsNullOrEmpty (hostName)) {
                return NotFound ();
            }
            return Ok (hostName);
            //UserSettings
        }

        [HttpGet ("user", Name = "settings_user")]
        [ProducesResponseType (200)]
        [ProducesResponseType (400)]
        public ActionResult<UserSettings> GetUserSettings () {

            try {
                var userSettings = this.configuration.GetSection ("User").Get<UserSettings> ();
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

    }
}