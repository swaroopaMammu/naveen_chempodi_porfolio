import '../models/cinematograpghy_modals.dart';

class CinemaRepository{

  List<FeaturedWork> getFeatureWork(){
    return {
      FeaturedWork(trailerId: "p9OUqWSqPZI",
          filmName: "Co-fee",
          yearOfRelease: "2025",
          credit: Credit(
              director: "Anoop sathyan",
              production:"",
              screenplay: "",
              editor: "",
              art_director: "",
              di: "",
              music: "",
              sync_sound: ""
          ),
          category: "Advertisement",
          description:"For Alice is a Malayalam short film narrating about the complex relationship between a mother and her daughter.",
          poster: "https://img.youtube.com/vi/p9OUqWSqPZI/0.jpg",
          videoPaths: {"assets/videos/cofee_video.mp4"}.toList()),
      FeaturedWork(trailerId: "LLjLGWoKJ34",
          filmName: "Ashiyan",
          yearOfRelease: "2022",
          credit: Credit(
              director: "",
              production:"",
              screenplay: "",
              editor: "",
              music: "",
              art_director: "",
              di: "",
              sync_sound: ""
          ),
          description:"For Alice is a Malayalam short film narrating about the complex relationship between a mother and her daughter.",
          category: "Advertisement",
          poster: "https://img.youtube.com/vi/LLjLGWoKJ34/0.jpg",
          videoPaths: {"assets/images/image4.jpeg","assets/images/image3.jpeg","assets/images/image2.jpeg"}.toList()),
      FeaturedWork(trailerId: "8KHm0PcVN2I&t=176s",
          filmName: "Priceless smile",
          yearOfRelease: "2022",
          credit: Credit(
              director: "",
              production:"",
              screenplay: "",
              editor: "",
              art_director: "",
              di: "",
              music: "",
              sync_sound: ""
          ),
          description:"For Alice is a Malayalam short film narrating about the complex relationship between a mother and her daughter.",
          category: "Advertisement",
          poster: "https://img.youtube.com/vi/8KHm0PcVN2I/0.jpg",
          videoPaths: {"assets/videos/priceless_smile_video_1.mp4","assets/videos/priceless_smile_video_2.mp4"}.toList()),
      FeaturedWork(trailerId: "FvdGBOpMSlU",
          filmName: "For Alice",
          yearOfRelease: "2021",
          credit: Credit(
            director: "Cathy Jeethu",
            production:"Bedtime stories",
            screenplay: "Cathy Jeethu",
            editor: "Unnikrishnan Gopinathan",
            art_director: "Rajesh P Velayudhan",
            music: "",
            di: "",
            sync_sound: ""
          ),
          category: "Short film",
          description:"A crime thriller that unravels love, betrayal, and the complex bond of a mother and daughter.",
          poster: "https://img.youtube.com/vi/FvdGBOpMSlU/0.jpg",
          videoPaths: {"assets/videos/for_alice_video_1.mp4","assets/videos/for_alice_video_2.mp4","assets/videos/for_alice_video_3.mp4"}.toList()),
      FeaturedWork(trailerId: "FWg1O5byix4",
          filmName: "CID moosa",
          yearOfRelease: "2021",
          credit: Credit(
              director: "",
              production:"Boldova Productions",
              screenplay: "KS Harishankar",
              editor: "Renjith Varma",
              art_director: "Jayan Cryon",
              di: "Arjun Menon",
              music: "",
              sync_sound: "Shibin"
          ),
          description:"A reimagined cover of a popular movie song, blending its original melody with modern remix elements for a fresh yet emotive experience.",
          category: "Music video",
          poster: "https://img.youtube.com/vi/FWg1O5byix4/0.jpg",
          videoPaths: {"assets/videos/cid_moosa_1.mp4","assets/videos/cid_moosa_2.mp4"}.toList()),
      FeaturedWork(trailerId: "aamCbjaaRVA",
          filmName: "Yoodhasinte loha",
          yearOfRelease: "2018",
          credit: Credit(
              director: "Umesh Krishnan - Biju menon",
              production:"U - Series Imaginations & B Film Factorory",
              screenplay: "Umesh krishnan",
              editor: "Suhas Rajendran",
              art_director: "Biju Menon",
              di: "",
              sync_sound: "",
              music: "Midhun Murali"
          ),
          category: "Short film",
          description:"A crime thriller rooted in scripture, where a killer blurs the line between sin and salvation.",
          poster: "https://img.youtube.com/vi/aamCbjaaRVA/0.jpg",
          videoPaths: {"assets/videos/yoodhasinte_loha_video_1.mp4"}.toList()),
      FeaturedWork(trailerId: "Dwhp1UrXe40",
          filmName: "Etho varmukilin",
          yearOfRelease: "2018",
          category: "Music video",
          description:"For Alice is a Malayalam short film narrating about the complex relationship between a mother and her daughter.",
          poster: "https://img.youtube.com/vi/Dwhp1UrXe40/0.jpg",
          credit: Credit(
              director: "Jathin Sankar Raj",
              production:"",
              screenplay: "",
              editor: "Bharath R",
              art_director: "Ajayan",
              di: "",
              music: "",
              sync_sound: ""
          ),
          videoPaths: {"assets/images/image4.jpeg","assets/images/image3.jpeg","assets/images/image2.jpeg"}.toList()),
      FeaturedWork(trailerId: "yI6AhvBy2oM",
          filmName: "Rainbow eclipse",
          yearOfRelease: "2017",
          category: "Music video",
          description:"A soulful cover of ‘Hurt,’ created as a tribute to the musician Trent Reznor.",
          poster: "https://img.youtube.com/vi/yI6AhvBy2oM/0.jpg",
          credit: Credit(
              director: "Audumber tapkir\nSwapnil dumbre\nSreeram nambiar",
              production:"Krishnan kurup",
              screenplay: "",
              editor: "Finn george.",
              art_director: "",
              di: "",
              music: "",
              sync_sound: ""
          ),
          videoPaths: {"assets/images/image4.jpeg","assets/images/image3.jpeg","assets/images/image2.jpeg"}.toList()),
      FeaturedWork(trailerId: "-5Fxe9S4NrI",
          filmName: "Menaka",
          yearOfRelease: "2019",
          category: "Web Series",
          credit: Credit(
              director: "Praveen K",
              production:"Renjith Nair",
              screenplay: "Devadas\nPraveen\nManoj Menon",
              music: "",
              editor: "",
              art_director: "",
              di: "",
              sync_sound: ""
          ),
          poster: "https://img.youtube.com/vi/-5Fxe9S4NrI/0.jpg",
          description:"A failed writer announces on TV his plan to commit 7 perfect murders in 7 days. After killing his first victim, a police team races to stop his meticulously planned crime spree.",
          videoPaths: {"assets/videos/menaka_video_1.mp4"}.toList()),
      FeaturedWork(trailerId: "gn0y0URMefw",
          filmName: "Ban plastic",
          yearOfRelease: "2018",
          credit: Credit(
              director: "",
              production:"",
              screenplay: "",
              editor: "",
              art_director: "",
              di: "",
              music: "",
              sync_sound: ""
          ),
          description:"For Alice is a Malayalam short film narrating about the complex relationship between a mother and her daughter.",
          category: "Advertisement",
          poster: "https://img.youtube.com/vi/gn0y0URMefw/0.jpg",
          videoPaths: {"assets/images/image4.jpeg","assets/images/image3.jpeg","assets/images/image2.jpeg"}.toList()),
    }.toList();
  }

  List<AssociatedWork> getFilms(){
    return {
      AssociatedWork(
        trailerId: "GkAUsuGMqm8",
          title: "Hrudayapoorvam",
          designation: "Associate Cameraman",
          poster: "assets/posters/Hridayapoorvam.jpg",
          ),
      AssociatedWork(
          trailerId: "ubVjt3eIDqA",
          title: "Padakkalam",
          designation: "Chief Associate Cameraman",
          poster: "assets/posters/padakkalam.jpeg"),
      AssociatedWork(
          trailerId: "PGqltBCo6cU",
          title: "L2:Empuram",
          designation: "Associate Cameraman",
          poster: "assets/posters/Empuraan_poster.jpg"),
      AssociatedWork(
          trailerId: "OCGGoT23kh4",
          title: "Kooman",
          designation: "Associate Cameraman",
          poster: "assets/posters/Kooman_poster.jpg"),
      AssociatedWork(
          trailerId: "uUJtUYkBu-g",
          title: "Dhrishyam 2",
          designation: "Associate Cameraman",
          poster: "assets/posters/drushyam_2_film_poster.jpg"),
      AssociatedWork(
          trailerId: "L13AUL0HkDk",
          title: "Kurup",
          designation: "Associate Cameraman",
          poster: "assets/posters/kurup.jpg"),
      AssociatedWork(
          trailerId: "4DTsMtDcbNo",
          title: "Padayottam",
          designation: "Associate Cameraman",
          poster: "assets/posters/padayottam.jpeg"),
      AssociatedWork(
          trailerId: "8-vWm6cDnak",
          title: "Aadhi",
          designation: "Associate Cameraman",
          poster: "assets/posters/aadhi.jpeg"),
      AssociatedWork(
          trailerId: "f9ym_s-CEmI",
          title: "Tiyaan",
          designation: "Associate Cameraman",
          poster: "assets/posters/Tiyaan_Movie_Poster.jpg"),
      AssociatedWork(
          trailerId: "cunn6W_9MM0",
          title: "Ore Mukham",
        designation: "Associate Cameraman",
          poster: "assets/posters/oremukham.jpg",)
    }.toList();
  }

  List<AssociatedWork> getWebSeries(){
    return {
      AssociatedWork(
          trailerId: "QPuOLNzPR7k",
        title: "Perilloor Premier League",
          designation: "Associate Cameraman",
        poster: "assets/posters/periloor.jpg"),
    }.toList();
  }

  List<AssociatedWork> getCommercials(){
    return {
      AssociatedWork(
        trailerId: "l4KadPBOa98",
        title: "Athiran",
          designation: "Associate Cameraman",
        poster: "https://img.youtube.com/vi/l4KadPBOa98/0.jpg"),
      AssociatedWork(
          trailerId: "90RcJ0udpKc",
          title: "Athiran",
          designation: "Associate Cameraman",
          poster: "https://img.youtube.com/vi/90RcJ0udpKc/0.jpg"),
      AssociatedWork(
          trailerId: "HaXVOBi2Y30",
          title: "Athiran",
          designation: "Associate Cameraman",
          poster: "https://img.youtube.com/vi/HaXVOBi2Y30/0.jpg"),
      AssociatedWork(
          trailerId: "fFwOgt3YO1U",
          title: "Athiran",
          designation: "Associate Cameraman",
          poster: "https://img.youtube.com/vi/fFwOgt3YO1U/0.jpg"),
      AssociatedWork(
          trailerId: "DIALEvmlhDQ",
          title: "Athiran",
          designation: "Associate Cameraman",
          poster: "https://img.youtube.com/vi/DIALEvmlhDQ/0.jpg"),
      AssociatedWork(
          trailerId: "2A5Krtb310o",
          title: "Athiran",
          designation: "Associate Cameraman",
          poster: "https://img.youtube.com/vi/2A5Krtb310o/0.jpg"),
      AssociatedWork(
          trailerId: "pViKP5JnM2w",
          title: "Athiran",
          designation: "Associate Cameraman",
          poster: "https://img.youtube.com/vi/pViKP5JnM2w/0.jpg"),
      AssociatedWork(
          trailerId: "Ilrs-OWSpuY",
          title: "Athiran",
          designation: "Associate Cameraman",
          poster: "https://img.youtube.com/vi/Ilrs-OWSpuY/0.jpg")
    }.toList();
  }
}