defmodule Sesopenko.ECS.RepositoryTest do
  alias Sesopenko.ECS.Repository
  use ExUnit.Case

  describe "creating and fetching an entity by entity id" do
    scenarios = [
      %{
        label: "creating one entity, multiple components",
        input_entities: [
          %{
            fruit_component: %{
              quantity: 100
            },
            position_component: %{
              x: 5,
              y: 13
            }
          }
        ],
        last_entity_expected: %{
          fruit_component: %{
            quantity: 100
          },
          position_component: %{
            x: 5,
            y: 13
          }
        }
      },
      %{
        label: "creating one entity, one component",
        input_entities: [
          %{
            fruit_component: %{
              quantity: 100
            }
          }
        ],
        last_entity_expected: %{
          fruit_component: %{
            quantity: 100
          }
        }
      },
      %{
        label: "creating multiple entities, one component",
        input_entities: [
          %{
            fruit_component: %{
              quantity: 20
            }
          },
          %{
            fruit_component: %{
              quantity: 100
            }
          }
        ],
        last_entity_expected: %{
          fruit_component: %{
            quantity: 100
          }
        }
      },
      %{
        label: "creating multiple entities, multiple components",
        input_entities: [
          %{
            fruit_component: %{
              quantity: 20
            },
            stomache_component: %{
              level: 30
            }
          },
          %{
            fruit_component: %{
              quantity: 4
            },
            stomache_component: %{
              level: 17
            }
          }
        ],
        last_entity_expected: %{
          fruit_component: %{
            quantity: 4
          },
          stomache_component: %{
            level: 17
          }
        }
      }
    ]

    for scenario <- scenarios do
      @tag input_entities: scenario[:input_entities]
      @tag last_entity_expected: scenario[:last_entity_expected]
      test scenario.label, context do
        # Arrange.
        last_entity_expected = context.last_entity_expected
        {:ok, repo_pid} = Repository.start_link()

        inserted =
          Enum.map(context.input_entities, fn input_entity_data ->
            {:ok, entity_id} = GenServer.call(repo_pid, {:add_entity, input_entity_data})
            entity_id
          end)

        entity_id = List.last(inserted)

        # Act.
        {:ok, entity_data} = GenServer.call(repo_pid, {:fetch_entity, entity_id})

        # Assert.

        for component_name <- Map.keys(last_entity_expected) do
          expected_data = last_entity_expected[component_name]
          assert Map.has_key?(entity_data, component_name)

          assert entity_data[component_name] == expected_data
        end

        assert Map.has_key?(entity_data, :fruit_component)

        # Cleanup
        GenServer.stop(repo_pid)
      end
    end
  end

  describe "walking all data for a component type" do
    scenarios = [
      %{
        label: "does not have component",
        input_component_type: :missing_component_type,
        expected_length: 0,
        input_entity_data: [
          %{
            fruit_component: %{
              quantity: 20
            },
            stomache_component: %{
              level: 30
            }
          }
        ]
      },
      %{
        label: "has one entity worth of data",
        input_component_type: :fruit_component,
        expected_length: 1,
        input_entity_data: [
          %{
            fruit_component: %{
              quantity: 20
            },
            stomache_component: %{
              level: 30
            }
          }
        ]
      },
      %{
        label: "has multiple entities worth of data",
        input_component_type: :fruit_component,
        expected_length: 2,
        input_entity_data: [
          %{
            fruit_component: %{
              quantity: 20
            },
            stomache_component: %{
              level: 30
            }
          },
          %{
            fruit_component: %{
              quantity: 20
            },
            stomache_component: %{
              level: 30
            }
          }
        ]
      }
    ]

    for scenario <- scenarios do
      @tag input_component_type: scenario.input_component_type
      @tag expected_length: scenario.expected_length
      @tag input_entity_data: scenario.input_entity_data
      test scenario.label, context do
        # Arrange.
        input_component_type = context.input_component_type
        expected_length = context.expected_length
        input_entity_data = context.input_entity_data
        {:ok, repo_pid} = Repository.start_link()

        for input_singular <- input_entity_data do
          {:ok, _} = GenServer.call(repo_pid, {:add_entity, input_singular})
        end

        # Act.
        {:ok, data} =
          GenServer.call(repo_pid, {:list_data_for_component_type, input_component_type})

        # Assert.
        assert length(data) == expected_length
      end
    end
  end
end
