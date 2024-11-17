import {
  assert,
  describe,
  test,
  clearStore,
  beforeAll,
  afterAll
} from "matchstick-as/assembly/index"
import { BigInt, Address } from "@graphprotocol/graph-ts"
import { QuestionCreated } from "../generated/schema"
import { QuestionCreated as QuestionCreatedEvent } from "../generated/Polymarket/Polymarket"
import { handleQuestionCreated } from "../src/polymarket"
import { createQuestionCreatedEvent } from "./polymarket-utils"

// Tests structure (matchstick-as >=0.5.0)
// https://thegraph.com/docs/en/developer/matchstick/#tests-structure-0-5-0

describe("Describe entity assertions", () => {
  beforeAll(() => {
    let id = BigInt.fromI32(234)
    let question = "Example string value"
    let timestamp = BigInt.fromI32(234)
    let createdBy = Address.fromString(
      "0x0000000000000000000000000000000000000001"
    )
    let creatorImageHash = "Example string value"
    let totalAmount = BigInt.fromI32(234)
    let totalYesAmount = BigInt.fromI32(234)
    let totalNoAmount = BigInt.fromI32(234)
    let newQuestionCreatedEvent = createQuestionCreatedEvent(
      id,
      question,
      timestamp,
      createdBy,
      creatorImageHash,
      totalAmount,
      totalYesAmount,
      totalNoAmount
    )
    handleQuestionCreated(newQuestionCreatedEvent)
  })

  afterAll(() => {
    clearStore()
  })

  // For more test scenarios, see:
  // https://thegraph.com/docs/en/developer/matchstick/#write-a-unit-test

  test("QuestionCreated created and stored", () => {
    assert.entityCount("QuestionCreated", 1)

    // 0xa16081f360e3847006db660bae1c6d1b2e17ec2a is the default address used in newMockEvent() function
    assert.fieldEquals(
      "QuestionCreated",
      "0xa16081f360e3847006db660bae1c6d1b2e17ec2a-1",
      "question",
      "Example string value"
    )
    assert.fieldEquals(
      "QuestionCreated",
      "0xa16081f360e3847006db660bae1c6d1b2e17ec2a-1",
      "timestamp",
      "234"
    )
    assert.fieldEquals(
      "QuestionCreated",
      "0xa16081f360e3847006db660bae1c6d1b2e17ec2a-1",
      "createdBy",
      "0x0000000000000000000000000000000000000001"
    )
    assert.fieldEquals(
      "QuestionCreated",
      "0xa16081f360e3847006db660bae1c6d1b2e17ec2a-1",
      "creatorImageHash",
      "Example string value"
    )
    assert.fieldEquals(
      "QuestionCreated",
      "0xa16081f360e3847006db660bae1c6d1b2e17ec2a-1",
      "totalAmount",
      "234"
    )
    assert.fieldEquals(
      "QuestionCreated",
      "0xa16081f360e3847006db660bae1c6d1b2e17ec2a-1",
      "totalYesAmount",
      "234"
    )
    assert.fieldEquals(
      "QuestionCreated",
      "0xa16081f360e3847006db660bae1c6d1b2e17ec2a-1",
      "totalNoAmount",
      "234"
    )

    // More assert options:
    // https://thegraph.com/docs/en/developer/matchstick/#asserts
  })
})
