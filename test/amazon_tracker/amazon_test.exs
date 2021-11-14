defmodule AmazonTracker.AmazonTest do
  use AmazonTracker.DataCase

  alias AmazonTracker.Amazon

  describe "products" do
    alias AmazonTracker.Amazon.Product

    import AmazonTracker.AmazonFixtures

    @invalid_attrs %{title: nil, url: nil, image: nil}

    # test "list_products/0 returns all products" do
    #   product = product_fixture()
    #   assert Amazon.list_products() == [product]
    # end

    # test "get_product!/1 returns the product with given id" do
    #   product = product_fixture()
    #   assert Amazon.get_product!(product.id) == product
    # end

    test "create_product/1 with valid data creates a product" do
      valid_attrs = %{title: "some title", url: "some url", image: "some-image"}

      assert {:ok, %Product{} = product} = Amazon.create_product(valid_attrs)
      assert product.title == "some title"
      assert product.url == "some url"
    end

    test "create_product/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Amazon.create_product(@invalid_attrs)
    end

    test "update_product/2 with valid data updates the product" do
      product = product_fixture()

      update_attrs = %{
        title: "some updated title",
        url: "some updated url",
        image: "some-image"
      }

      assert {:ok, %Product{} = product} = Amazon.update_product(product, update_attrs)
      assert product.title == "some updated title"
      assert product.url == "some updated url"
    end

    # test "update_product/2 with invalid data returns error changeset" do
    #   product = product_fixture()
    #   assert {:error, %Ecto.Changeset{}} = Amazon.update_product(product, @invalid_attrs)
    #   assert product == Amazon.get_product!(product.id)
    # end

    test "delete_product/1 deletes the product" do
      product = product_fixture()
      assert {:ok, %Product{}} = Amazon.delete_product(product)
      assert_raise Ecto.NoResultsError, fn -> Amazon.get_product!(product.id) end
    end

    test "change_product/1 returns a product changeset" do
      product = product_fixture()
      assert %Ecto.Changeset{} = Amazon.change_product(product)
    end
  end
end
