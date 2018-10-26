namespace TodoApi.Models
{
     public class ProfileSettings {
        public string Region { get; set; }
        public int DeliveryFrequency { get; set; }
        public bool IsSubscribed { get; set; }

    }

    public class ServiceSubscription {
        public string AccountId { get; set; }
        public string EncryptionHash { get; set; }
        public string Password { get; set; }

    }



}