defmodule AmazonTracker.TrackerTest do
  use ExUnit.Case, async: true
  alias AmazonTracker.Amazon.Scraper

  test "scrapes amazon product information" do
    url = "https://www.amazon.it/gp/product/B08DRSHH8T"
    {:ok, product} = Scraper.scrape(%{url: url})

    assert product.title
    assert product.image
    assert product.url
    # assert product.price

    # assert product == %AmazonTracker.Amazon.Product{
    #          title:
    #            "Philips 288E2A Gaming Monitor 28\", IPS 4K UHD 3840x2160, 300cd/m², Tempo di risposta 4ms, AMD FreeSync, Audio integrato, Multiview ( PIP, PBP ), 2xHDMI / Display Port / Vesa / Nero",
    #          image:
    #            "https://images-eu.ssl-images-amazon.com/images/I/814bLzhFcoL.__AC_SX300_SY300_QL70_ML2_.jpg",
    #          url: "https://www.amazon.it/gp/product/B08DRSHH8T",
    #          price: 249.9
    #        }
  end
end
